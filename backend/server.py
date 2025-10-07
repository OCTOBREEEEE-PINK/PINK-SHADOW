import os
import asyncio
import secrets
from datetime import datetime, timedelta, timezone
from typing import Optional, List, Dict, Any

from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from motor.motor_asyncio import AsyncIOMotorClient, AsyncIOMotorDatabase
from pydantic import BaseModel, Field


# -----------------------------
# Config & Security
# -----------------------------

# Configuration simplifiée sans authentification

MONGODB_URI = os.getenv("MONGODB_URI", "mongodb://localhost:27017")
MONGODB_DB = os.getenv("MONGODB_DB", "escape_game")
# Room timer (seconds) applied to each room when started; if not started, no limit
ROOM_TIMER_SECONDS = int(os.getenv("ROOM_TIMER_SECONDS", "0"))  # 0 disables timers

# Optional symmetric encryption for sensitive message content
from cryptography.fernet import Fernet, InvalidToken

ENCRYPTION_KEY = os.getenv("ENCRYPTION_KEY")
if not ENCRYPTION_KEY:
    # Ephemeral key if not provided; for production set ENCRYPTION_KEY
    ENCRYPTION_KEY = Fernet.generate_key().decode()
fernet = Fernet(ENCRYPTION_KEY.encode())

# Authentification simplifiée - pas de mots de passe


# -----------------------------
# App and DB
# -----------------------------

app = FastAPI(title="Escape Game Backend", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

mongo_client: Optional[AsyncIOMotorClient] = None
db: Optional[AsyncIOMotorDatabase] = None


@app.on_event("startup")
async def on_startup() -> None:
    global mongo_client, db
    mongo_client = AsyncIOMotorClient(MONGODB_URI)
    db = mongo_client[MONGODB_DB]
    # Create Indexes
    await db.users.create_index("pseudo", unique=True)
    await db.sessions.create_index("code", unique=True)
    await db.messages.create_index([("session_id", 1), ("created_at", 1)])


@app.on_event("shutdown")
async def on_shutdown() -> None:
    if mongo_client is not None:
        mongo_client.close()


# -----------------------------
# Models
# -----------------------------

class UserCreate(BaseModel):
    pseudo: str = Field(min_length=3, max_length=32)


class UserPublic(BaseModel):
    pseudo: str


class SessionCreate(BaseModel):
    name: str = Field(min_length=3, max_length=64)


class SessionJoin(BaseModel):
    inventory: Optional[List[str]] = None


class InventoryUpdate(BaseModel):
    add: Optional[List[str]] = None
    remove: Optional[List[str]] = None


class RoomProgressUpdate(BaseModel):
    room: int = Field(ge=1, le=6)
    state: Dict[str, Any] = Field(default_factory=dict)


class FinalAnswer(BaseModel):
    answer: str


class ChatMessageCreate(BaseModel):
    content: str = Field(min_length=1, max_length=2000)


class ChatMessagePublic(BaseModel):
    pseudo: str
    content: str
    created_at: datetime


class TimerInfo(BaseModel):
    room: int
    started_at: Optional[datetime] = None
    expires_at: Optional[datetime] = None
    remaining_seconds: Optional[int] = None


# -----------------------------
# Security Helpers
# -----------------------------

# Fonction simplifiée pour obtenir le pseudo depuis les paramètres de requête
async def get_current_user(pseudo: str) -> str:
    return pseudo


# -----------------------------
# Auth Endpoints
# -----------------------------

@app.post("/auth/register", response_model=UserPublic, status_code=201)
async def register_user(payload: UserCreate) -> UserPublic:
    # Enregistrement simplifié sans mot de passe
    assert db is not None
    user_doc = {
        "pseudo": payload.pseudo,
        "created_at": datetime.now(timezone.utc),
    }
    try:
        await db.users.insert_one(user_doc)
    except Exception as e:
        # Likely duplicate key
        raise HTTPException(status_code=409, detail="Pseudo already exists")
    return UserPublic(pseudo=payload.pseudo)


@app.get("/me", response_model=UserPublic)
async def me(pseudo: str) -> UserPublic:
    return UserPublic(pseudo=pseudo)


# -----------------------------
# Session & Game Logic
# -----------------------------

def generate_session_code() -> str:
    return secrets.token_urlsafe(6)


DEFAULT_ROOM_STATES = {
    str(i): {
        "completed": False,
        "data": {},
        # timer fields are optional and set via start endpoint
        # "timer": {"started_at": datetime, "expires_at": datetime}
    }
    for i in range(1, 7)
}


@app.post("/sessions", status_code=201)
async def create_session(payload: SessionCreate, pseudo: str) -> Dict[str, Any]:
    assert db is not None
    code = generate_session_code()
    doc = {
        "name": payload.name,
        "code": code,
        "owner": pseudo,
        "players": [],  # list of pseudos
        "current_room": 1,
        "room_states": DEFAULT_ROOM_STATES.copy(),
        "final_answer_hash": None,  # Optional: can be set by owner later
        "created_at": datetime.now(timezone.utc),
        "finished": False,
    }
    await db.sessions.insert_one(doc)
    return {"session_id": str(doc["code"]), "code": code, "name": payload.name}


async def get_session_or_404(code: str) -> Dict[str, Any]:
    assert db is not None
    session = await db.sessions.find_one({"code": code})
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return session


def _compute_timer_remaining(timer: Optional[Dict[str, Any]]) -> Optional[int]:
    if not timer:
        return None
    expires_at = timer.get("expires_at")
    if not isinstance(expires_at, datetime):
        return None
    now = datetime.now(timezone.utc)
    remaining = int((expires_at - now).total_seconds())
    return max(0, remaining)


@app.get("/sessions/{code}")
async def get_session(code: str, pseudo: str) -> Dict[str, Any]:
    session = await get_session_or_404(code)
    # Redact sensitive fields
    session.pop("_id", None)
    session.pop("final_answer_hash", None)
    # Add computed remaining_seconds per room if timer exists
    room_states = session.get("room_states", {})
    for rk, state in room_states.items():
        timer = state.get("timer")
        state["remaining_seconds"] = _compute_timer_remaining(timer)
    return session


@app.post("/sessions/{code}/join")
async def join_session(code: str, payload: SessionJoin, pseudo: str) -> Dict[str, Any]:
    assert db is not None
    session = await get_session_or_404(code)
    if session.get("finished"):
        raise HTTPException(status_code=400, detail="Session is finished")
    players: List[str] = session.get("players", [])
    if pseudo in players:
        return {"ok": True, "message": "Already joined"}
    if len(players) >= 5:
        raise HTTPException(status_code=403, detail="Session is full (max 5 players)")
    await db.sessions.update_one({"code": code}, {"$addToSet": {"players": pseudo}})
    # Create or upsert player state
    await db.player_states.update_one(
        {"session_code": code, "pseudo": pseudo},
        {
            "$setOnInsert": {
                "inventory": payload.inventory or [],
                "progress": {"current_room": 1},
                "created_at": datetime.now(timezone.utc),
            }
        },
        upsert=True,
    )
    return {"ok": True}


@app.post("/sessions/{code}/leave")
async def leave_session(code: str, pseudo: str) -> Dict[str, Any]:
    assert db is not None
    session = await get_session_or_404(code)
    if pseudo not in session.get("players", []):
        return {"ok": True, "message": "Not in session"}
    await db.sessions.update_one({"code": code}, {"$pull": {"players": pseudo}})
    return {"ok": True}


@app.get("/sessions/{code}/players")
async def list_players(code: str, pseudo: str) -> Dict[str, Any]:
    session = await get_session_or_404(code)
    return {"players": session.get("players", [])}


@app.get("/connected-players")
async def get_connected_players() -> Dict[str, Any]:
    """Retourne tous les joueurs actuellement connectés via WebSocket"""
    connected_players = {}
    for session_code, players in manager.active_connections.items():
        connected_players[session_code] = list(players.keys())
    
    total_connected = sum(len(players) for players in connected_players.values())
    
    return {
        "total_connected_players": total_connected,
        "sessions": connected_players,
        "all_players": [player for players in connected_players.values() for player in players],
        "summary": f"{total_connected} joueur(s) connecté(s) sur {len(connected_players)} session(s)"
    }

# Timer global pour synchroniser tous les joueurs
global_timer = {
    "started_at": None,
    "duration": 480,  # 8 minutes en secondes
    "is_running": False
}

# Stockage des émojis des joueurs
player_emojis = {}

@app.get("/timer")
async def get_timer() -> Dict[str, Any]:
    """Retourne l'état du timer global"""
    if not global_timer["is_running"] or not global_timer["started_at"]:
        return {
            "remaining_seconds": global_timer["duration"],
            "is_running": False,
            "started_at": None
        }
    
    elapsed = (datetime.now() - global_timer["started_at"]).total_seconds()
    remaining = max(0, global_timer["duration"] - elapsed)
    
    return {
        "remaining_seconds": int(remaining),
        "is_running": global_timer["is_running"],
        "started_at": global_timer["started_at"].isoformat()
    }

@app.post("/timer/start")
async def start_timer():
    """Démarre le timer global"""
    global_timer["started_at"] = datetime.now()
    global_timer["is_running"] = True
    return {"message": "Timer démarré", "started_at": global_timer["started_at"].isoformat()}

@app.post("/timer/stop")
async def stop_timer():
    """Arrête le timer global"""
    global_timer["is_running"] = False
    global_timer["started_at"] = None
    return {"message": "Timer arrêté"}

@app.post("/players/{pseudo}/emoji")
async def set_player_emoji(pseudo: str, emoji: dict):
    """Définit l'émoji d'un joueur"""
    player_emojis[pseudo] = emoji.get("emoji", "🌸")
    return {"message": f"Émoji défini pour {pseudo}", "emoji": player_emojis[pseudo]}

@app.get("/players/emojis")
async def get_all_emojis():
    """Retourne tous les émojis des joueurs"""
    return {"emojis": player_emojis}


@app.post("/sessions/{code}/inventory")
async def update_inventory(code: str, payload: InventoryUpdate, pseudo: str) -> Dict[str, Any]:
    assert db is not None
    await get_session_or_404(code)
    ops: Dict[str, Any] = {}
    if payload.add:
        ops.setdefault("$addToSet", {})["inventory"] = {"$each": payload.add}
    if payload.remove:
        ops.setdefault("$pull", {})["inventory"] = {"$in": payload.remove}
    if not ops:
        return {"ok": True}
    await db.player_states.update_one({"session_code": code, "pseudo": pseudo}, ops, upsert=True)
    return {"ok": True}


@app.post("/sessions/{code}/rooms/progress")
async def update_room_progress(code: str, payload: RoomProgressUpdate, pseudo: str) -> Dict[str, Any]:
    assert db is not None
    session = await get_session_or_404(code)
    if pseudo not in session.get("players", []):
        raise HTTPException(status_code=403, detail="Join the session first")

    room_key = str(payload.room)
    # Basic rule: You can only update current or next room sequentially
    current_room = session.get("current_room", 1)
    if payload.room > current_room + 1:
        raise HTTPException(status_code=400, detail="Cannot skip rooms")

    # Enforce timer if configured and started
    if ROOM_TIMER_SECONDS > 0:
        timer = session.get("room_states", {}).get(room_key, {}).get("timer")
        remaining = _compute_timer_remaining(timer)
        if timer and remaining is not None and remaining == 0:
            raise HTTPException(status_code=403, detail="Room timer expired")

    # Update room state globally
    room_state_path = f"room_states.{room_key}"
    new_state = {
        "completed": bool(payload.state.get("completed", False)),
        "data": payload.state.get("data", {}),
        "updated_by": pseudo,
        "updated_at": datetime.now(timezone.utc),
    }
    updates = {"$set": {room_state_path: new_state}}
    # If completed, move to next room (max 6)
    if new_state["completed"] and payload.room == current_room and current_room < 6:
        updates["$set"]["current_room"] = current_room + 1
    await db.sessions.update_one({"code": code}, updates)

    # Track per-player progress as well
    await db.player_states.update_one(
        {"session_code": code, "pseudo": pseudo},
        {"$set": {"progress.current_room": min(payload.room + (1 if new_state["completed"] else 0), 6)}},
        upsert=True,
    )

    return {"ok": True}


@app.post("/sessions/{code}/final/submit")
async def submit_final_answer(code: str, payload: FinalAnswer, pseudo: str) -> Dict[str, Any]:
    assert db is not None
    session = await get_session_or_404(code)
    if session.get("current_room", 1) < 6:
        raise HTTPException(status_code=400, detail="Final room not unlocked yet")

    # Enforce timer on room 6 if configured
    if ROOM_TIMER_SECONDS > 0:
        timer = session.get("room_states", {}).get("6", {}).get("timer")
        remaining = _compute_timer_remaining(timer)
        if timer and remaining is not None and remaining == 0:
            raise HTTPException(status_code=403, detail="Final room timer expired")

    # For demo: consider the answer correct if it matches a session field or a static secret
    # In production, store a hashed expected answer in session["final_answer_hash"] and compare
    expected = os.getenv("FINAL_ANSWER", "OPEN-SESAME")
    is_correct = payload.answer.strip().lower() == expected.strip().lower()
    if is_correct:
        await db.sessions.update_one({"code": code}, {"$set": {"finished": True, "finished_at": datetime.now(timezone.utc)}})
    return {"correct": is_correct}


# -----------------------------
# Chat (WebSocket + History)
# -----------------------------

class ConnectionManager:
    def __init__(self) -> None:
        self.active_connections: Dict[str, Dict[str, WebSocket]] = {}

    async def connect(self, session_code: str, pseudo: str, websocket: WebSocket) -> None:
        await websocket.accept()
        self.active_connections.setdefault(session_code, {})[pseudo] = websocket

    def disconnect(self, session_code: str, pseudo: str) -> None:
        if session_code in self.active_connections and pseudo in self.active_connections[session_code]:
            self.active_connections[session_code].pop(pseudo, None)
            if not self.active_connections[session_code]:
                self.active_connections.pop(session_code, None)

    async def broadcast(self, session_code: str, message: Dict[str, Any]) -> None:
        connections = list(self.active_connections.get(session_code, {}).values())
        for ws in connections:
            try:
                await ws.send_json(message)
            except Exception:
                # Ignore send errors; clients may have gone away
                pass


manager = ConnectionManager()


# Fonction d'authentification WebSocket supprimée - plus nécessaire


def encrypt_message(text: str) -> str:
    return fernet.encrypt(text.encode()).decode()


def decrypt_message(token: str) -> str:
    try:
        return fernet.decrypt(token.encode()).decode()
    except InvalidToken:
        return "[decryption-error]"


@app.websocket("/ws/chat/{code}")
async def websocket_endpoint(websocket: WebSocket, code: str, pseudo: str) -> None:
    # Pseudo passé directement en paramètre de requête

    assert db is not None
    session = await db.sessions.find_one({"code": code})
    if not session:
        await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
        return
    if pseudo not in session.get("players", []) and pseudo != session.get("owner"):
        await websocket.close(code=status.WS_1008_POLICY_VIOLATION)
        return

    await manager.connect(code, pseudo, websocket)
    try:
        await manager.broadcast(code, {"system": True, "pseudo": "system", "content": f"{pseudo} joined", "created_at": datetime.now(timezone.utc).isoformat()})
        while True:
            data = await websocket.receive_json()
            content = str(data.get("content", "")).strip()
            if not content:
                continue
            enc = encrypt_message(content)
            msg_doc = {
                "session_id": code,
                "pseudo": pseudo,
                "content": enc,
                "created_at": datetime.now(timezone.utc),
            }
            await db.messages.insert_one(msg_doc)
            await manager.broadcast(code, {"pseudo": pseudo, "content": content, "created_at": msg_doc["created_at"].isoformat()})
    except WebSocketDisconnect:
        manager.disconnect(code, pseudo)
        await manager.broadcast(code, {"system": True, "pseudo": "system", "content": f"{pseudo} left", "created_at": datetime.now(timezone.utc).isoformat()})
    except Exception:
        manager.disconnect(code, pseudo)
        try:
            await websocket.close(code=status.WS_1011_INTERNAL_ERROR)
        except Exception:
            pass


@app.get("/sessions/{code}/chat/history", response_model=List[ChatMessagePublic])
async def chat_history(code: str, pseudo: str) -> List[ChatMessagePublic]:
    assert db is not None
    session = await get_session_or_404(code)
    if pseudo not in session.get("players", []) and pseudo != session.get("owner"):
        raise HTTPException(status_code=403, detail="Join the session first")
    cursor = db.messages.find({"session_id": code}).sort("created_at", 1)
    items: List[ChatMessagePublic] = []
    async for doc in cursor:
        items.append(ChatMessagePublic(pseudo=doc["pseudo"], content=decrypt_message(doc["content"]), created_at=doc["created_at"]))
    return items


# -----------------------------
# Health
# -----------------------------

@app.get("/healthz")
async def health() -> Dict[str, str]:
    return {"status": "ok"}


# -----------------------------
# Room Timers
# -----------------------------

@app.post("/sessions/{code}/rooms/{room}/timer/start", response_model=TimerInfo)
async def start_room_timer(code: str, room: int, pseudo: str) -> TimerInfo:
    assert db is not None
    if room < 1 or room > 6:
        raise HTTPException(status_code=400, detail="Invalid room")
    session = await get_session_or_404(code)
    if pseudo != session.get("owner"):
        raise HTTPException(status_code=403, detail="Only owner can start timer")
    if ROOM_TIMER_SECONDS <= 0:
        raise HTTPException(status_code=400, detail="Room timers are disabled")

    now = datetime.now(timezone.utc)
    expires = now + timedelta(seconds=ROOM_TIMER_SECONDS)
    room_key = str(room)
    await db.sessions.update_one(
        {"code": code},
        {"$set": {f"room_states.{room_key}.timer": {"started_at": now, "expires_at": expires}}},
    )
    return TimerInfo(room=room, started_at=now, expires_at=expires, remaining_seconds=ROOM_TIMER_SECONDS)


@app.get("/sessions/{code}/rooms/{room}/timer", response_model=TimerInfo)
async def get_room_timer(code: str, room: int, pseudo: str) -> TimerInfo:
    assert db is not None
    if room < 1 or room > 6:
        raise HTTPException(status_code=400, detail="Invalid room")
    session = await get_session_or_404(code)
    room_key = str(room)
    timer = session.get("room_states", {}).get(room_key, {}).get("timer")
    remaining = _compute_timer_remaining(timer)
    return TimerInfo(
        room=room,
        started_at=timer.get("started_at") if timer else None,
        expires_at=timer.get("expires_at") if timer else None,
        remaining_seconds=remaining,
    )


# -----------------------------
# Run with: uvicorn backend.server:app --reload
# -----------------------------


