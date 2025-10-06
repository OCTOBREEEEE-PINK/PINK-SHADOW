## Escape Game Backend (FastAPI + MongoDB)

### Prerequisites
- Python 3.10+
- MongoDB running (default: `mongodb://localhost:27017`)

### Environment
Set as needed (recommended in a `.env` in this `backend/` folder):
```
export MONGODB_URI="mongodb://localhost:27017"
export MONGODB_DB="escape_game"
export JWT_SECRET="change-me"
export ENCRYPTION_KEY="$(python -c 'from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())')"
export FINAL_ANSWER="OPEN-SESAME"
export ROOM_TIMER_SECONDS=0  # set >0 to enable per-room timers
```

### Install (from repo root)
```
python -m venv .venv
source .venv/bin/activate
pip install -r backend/requirements.txt
pip install -r backend/requirements-dev.txt  # optional (tests)
```

### Run
```
uvicorn backend.server:app --reload
```

### Quick Start (recommended)
1) Start MongoDB
```
docker compose -f backend/docker-compose.yml up -d mongo
```
2) Create venv and install deps
```
python -m venv .venv && source .venv/bin/activate
pip install -r backend/requirements.txt
```
3) Configure environment
```
cp backend/.env.example backend/.env
# edit backend/.env to set strong JWT_SECRET and ENCRYPTION_KEY
```
4) Launch API
```
backend/scripts/dev.sh
# or: uvicorn backend.server:app --reload
```
5) Open API docs
```
http://localhost:8000/docs
```

### Docker
```
docker compose -f backend/docker-compose.yml up -d mongo
docker build -f backend/Dockerfile -t escape-backend .
docker run --rm -p 8000:8000 --env-file backend/.env escape-backend
```

### Environment variables (backend/.env)
```
MONGODB_URI=mongodb://localhost:27017
MONGODB_DB=escape_game
JWT_SECRET=<strong-random>
ENCRYPTION_KEY=<fernet-key>  # generate: python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
FINAL_ANSWER=OPEN-SESAME
ROOM_TIMER_SECONDS=0  # set >0 to enable per-room timers
```

### API Overview
- POST `/auth/register` { pseudo, password }
- POST `/auth/login` (OAuth2PasswordRequestForm) -> bearer token
- GET `/me`
- POST `/sessions` { name }
- GET `/sessions/{code}`
- POST `/sessions/{code}/join`
- POST `/sessions/{code}/leave`
- GET `/sessions/{code}/players`
- POST `/sessions/{code}/inventory` { add, remove }
- POST `/sessions/{code}/rooms/progress` { room (1..6), state }
- POST `/sessions/{code}/final/submit` { answer }
- GET `/sessions/{code}/chat/history`
- WS `/ws/chat/{code}?token=Bearer <JWT>`

### Real-time chat (WebSocket)
- Connect (example with wscat):
```
wscat -c "ws://localhost:8000/ws/chat/<CODE>?token=Bearer <JWT>"
# then send: {"content":"Hello team!"}
```
- History: `GET /sessions/{code}/chat/history`

### Room timers
- Enable with `ROOM_TIMER_SECONDS > 0`.
- Start a timer (owner only): `POST /sessions/{code}/rooms/{room}/timer/start`
- Read timer: `GET /sessions/{code}/rooms/{room}/timer`
- Enforcement: when timer expires, room progress updates and final submission are rejected.

### Save progression
- Update after each room: `POST /sessions/{code}/rooms/progress`
- Session state (team): `GET /sessions/{code}` (includes `current_room`, `room_states`, and `remaining_seconds` per room if timer is set)

### Tests
```
pytest -q
```

### Smoke tests (IDE REST client)
Use `backend/api-smoke.http` and replace `<TOKEN>` with your JWT from `/auth/login`.

