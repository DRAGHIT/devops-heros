#!/usr/bin/env bash
set -euo pipefail
# Run from this student folder. PostgreSQL must already be running on localhost:5432.
export DATABASE_URL='postgresql+psycopg://taskboard:taskboard@localhost:5432/taskboard'
cd backend
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/alembic upgrade head
.venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000 > ../backend-manual.log 2>&1 &
echo $! > ../backend.pid
cd ../frontend
npm ci
npm run dev > ../frontend-manual.log 2>&1 &
echo $! > ../frontend.pid
