# Session 21 - TaskBoard homework

**Student:** Aditya Prasad<br>
**Roll number:** 24BCS10179

## Scope

This submission covers the homework specified by ma'am: run the provided frontend, backend and PostgreSQL manually, then build frontend/backend Dockerfiles and run the stack with `docker-compose up -d --build`; test `localhost:3000`, `/docs`, `/health` and `/metrics`; include actual output screenshots. It does not claim the larger teacher capstone's AWS/EKS, Helm, CI/CD or monitoring deployment.

Source: [teacher's TaskBoard application](https://github.com/Nency-Ravaliya/devops-heros/tree/main/session21-python). The original source outside this student folder is unchanged.

## Changes to the student copy

- Manual Vite server uses port **3000** and proxies `/api` to FastAPI **8000**. The teacher config used frontend 5173 and proxy 8080, which did not match this homework.
- Frontend dependencies are locked; its multi-stage Dockerfile uses `npm ci`, builds React/Vite, then serves it with Nginx. Backend uses Python 3.12, installs pinned requirements, runs Alembic and Uvicorn as a non-root user.
- PostgreSQL health check gates backend startup in Compose. Published Docker ports bind to loopback only.
- Pytest runs FastAPI lifespan so its SQLite-only unit-test table is created. Runtime verification below uses actual PostgreSQL, not SQLite.
- `taskboard/taskboard` is disposable classroom database data, not an account credential. Do not expose this configuration on the internet or use it for production.

## Method 1 - manual installation and processes

Install PostgreSQL 16 and Python 3.12, then create the local database:

```bash
sudo service postgresql start
sudo -u postgres psql
CREATE USER taskboard WITH PASSWORD 'taskboard';
CREATE DATABASE taskboard OWNER taskboard;
\q
```

From this student folder:

```bash
export DATABASE_URL='postgresql+psycopg://taskboard:taskboard@localhost:5432/taskboard'
cd backend
python3.12 -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/alembic upgrade head
.venv/bin/uvicorn app.main:app --host 0.0.0.0 --port 8000
# In a second terminal:
cd frontend
npm ci
npm run dev
```

The executed manual method uses an OS-installed PostgreSQL server, native Python/Uvicorn and native Node/Vite, **not Docker containers**. The host is a GitHub Codespace, not the student's personal laptop. The browser tested that host's real localhost ports, without public port forwarding.

### Application on localhost:3000

![Manual TaskBoard](evidence/manual/frontend.png)

### Backend docs on localhost:8000/docs

![Manual Swagger documentation](evidence/manual/docs.png)

### Backend health

![Manual health response](evidence/manual/health.png)

### Backend metrics

![Manual metrics response](evidence/manual/metrics.png)

### Backend and frontend process output

![Manual backend output](evidence/manual/backend-output.png)
![Manual frontend output](evidence/manual/frontend-output.png)

### Actual API checks, PostgreSQL rows and unit tests

![Manual API tests](evidence/manual/api-tests.png)
![Manual PostgreSQL](evidence/manual/database.png)
![Manual unit tests](evidence/manual/pytest.png)

Raw outputs: [setup and migration](evidence/manual/setup.log), [API tests](evidence/manual/api-tests.log), [database](evidence/manual/database.log), [pytest](evidence/manual/pytest.log), [backend](evidence/manual/backend.log), [frontend](evidence/manual/frontend.log).

## Method 2 - Dockerfiles and Docker Compose

Stop manual frontend/backend and PostgreSQL first to free 3000/8000/5432, then run from this student folder:

```bash
docker-compose up -d --build
# Modern equivalent: docker compose up -d --build
docker-compose ps
curl --fail http://localhost:8000/health
curl --fail http://localhost:8000/metrics
```

The execution used Docker Compose v5.5.1 `docker compose` through a small `docker-compose` wrapper, with project name `aditya-s21` to keep resources isolated. Docker builds both provided Dockerfiles; PostgreSQL runs from the official image with a named data volume. Nginx proxies `/api` to the backend service.

### Actual build output and running stack

![Compose build output](evidence/compose/build.png)
![Compose containers and images](evidence/compose/runtime.png)

### Application on localhost:3000

![Compose TaskBoard](evidence/compose/frontend.png)

### Backend docs, health and metrics

![Compose Swagger documentation](evidence/compose/docs.png)
![Compose health response](evidence/compose/health.png)
![Compose metrics response](evidence/compose/metrics.png)

### API checks and PostgreSQL rows

![Compose API tests](evidence/compose/api-tests.png)
![Compose PostgreSQL](evidence/compose/database.png)

Raw outputs: [complete build log](evidence/compose/build.log), [running containers/images](evidence/compose/runtime.log), [API tests](evidence/compose/api-tests.log), [database](evidence/compose/database.log), [service logs](evidence/compose/services.log).

## Test details

Both methods verify HTTP 200 for frontend, Swagger docs, health and metrics. The test also checks `/ready` with database access, OpenAPI, task creation/read/update/delete/list/stats and a kept proof task displayed in the actual frontend and PostgreSQL query. Metrics are returned from the real instrumented backend. [Verification script](scripts/verify.py).

UI/API images are real browser screenshots captured from the running localhost pages. Command-output images are **readable renderings of captured raw logs**, labeled accordingly, not fabricated terminal screenshots. The full logs are linked above. [Page capture](scripts/capture.mjs), [log rendering](scripts/logshots.mjs).

## Cleanup

```bash
docker-compose -p aditya-s21 down -v --remove-orphans
```

[Cleanup output](evidence/compose/cleanup.log) records the completed teardown. Only this homework's processes, containers and volume are removed. The Codespace was deleted after preserving the evidence, so the localhost app is not a permanent hosted deployment.

![Completed cleanup](evidence/compose/cleanup.png)

## Results and troubleshooting

- Manual: three backend unit tests passed with three upstream deprecation warnings. The actual live API tests used PostgreSQL, not the tests' SQLite database. Frontend production bundle also built successfully.
- Both methods: frontend and all required endpoints returned HTTP 200; real database readiness and task CRUD passed.
- Initial manual setup used `sudo -u postgres`, which the Codespace sudo policy did not allow directly. Retried through root `runuser`; database creation and migrations then succeeded. [Initial output](evidence/manual/initial-setup-failure.log).
- Compose initially could not reach PostgreSQL because Codespaces had a legacy `FORWARD DROP` rule while Docker used nftables. Allowed forwarding only within this exercise's Docker bridge, restarted the backend, then all tests passed. Removed the scoped rule during cleanup. This host-specific fix is not normally needed on Docker Desktop. Startup connection-reset probes remain in the full build log.
- The teacher's greeting/profile and activity feed are static demo UI content; task rows and counters shown here come from the actual API/database. No CI deployment or monitoring dashboard is claimed by those decorative labels.

## Submission

Submit this README's GitHub link in the Google Form. The form has not been submitted by this project.
