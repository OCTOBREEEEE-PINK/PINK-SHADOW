import os
import asyncio
import pytest
from httpx import AsyncClient
from fastapi import status

os.environ.setdefault("MONGODB_URI", "mongodb://localhost:27017")
os.environ.setdefault("MONGODB_DB", "escape_game_test")
os.environ.setdefault("JWT_SECRET", "test-secret")

from backend.server import app  # noqa: E402


@pytest.mark.asyncio
async def test_register_login_create_session(monkeypatch):
    async with AsyncClient(app=app, base_url="http://test") as client:
        # Register
        r = await client.post("/auth/register", json={"pseudo": "tester", "password": "secret123"})
        assert r.status_code in (201, 409)

        # Login
        r = await client.post("/auth/login", data={"username": "tester", "password": "secret123"})
        assert r.status_code == 200
        token = r.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}

        # Create session
        r = await client.post("/sessions", json={"name": "Test"}, headers=headers)
        assert r.status_code == 201
        code = r.json()["code"]

        # Join session
        r = await client.post(f"/sessions/{code}/join", json={}, headers=headers)
        assert r.status_code == 200

        # Players list
        r = await client.get(f"/sessions/{code}/players", headers=headers)
        assert r.status_code == 200
        assert "tester" in r.json()["players"]

