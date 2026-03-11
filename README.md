# Marketplace Prototype - Infrastructure Stack

This repository contains the orchestration logic for the Marketplace Prototype project. It manages the local development stack using Docker Compose.

## Prerequisites

- [Docker](https://www.docker.com/get-started) & [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

## Getting Started

To launch the entire stack (Backend, Frontend, Database, and S3 Storage), follow these steps:

### 1. Clone the Repositories

This project consists of three separate repositories. Ensure they are cloned into the same parent directory:

```bash
# Clone the infrastructure stack (this repo)
git clone <infra-repo-url> marketplace-stack

# Clone the backend
git clone <backend-repo-url> marketplace-backend

# Clone the frontend
git clone <frontend-repo-url> marketplace-frontend
```

### 2. Configure Environment

Copy the example environment file and adjust the values if necessary:

```bash
cd marketplace-stack
cp .env.example .env
```

### 3. Launch the Stack

Run the following command to build and start all containers in detached mode:

```bash
docker compose up -d --build
```

### 4. Verify the Services

| Service           | URL                                            | Description                       |
| ----------------- | ---------------------------------------------- | --------------------------------- |
| **Backend API**   | [http://localhost:8000](http://localhost:8000) | FastAPI Documentation / API       |
| **Frontend UI**   | [http://localhost:5173](http://localhost:5173) | Vite/Vue 3 Application            |
| **MinIO Console** | [http://localhost:9001](http://localhost:9001) | S3 Management UI (admin/changeme) |
| **PostgreSQL**    | `localhost:5432`                               | Database Service                  |

## Key Features

- **Healthchecks**: The backend service automatically waits for PostgreSQL and MinIO to be `healthy` before starting.
- **Persistence**: Database data and S3 objects are persisted in the `./volumes` directory.
- **Strictly Async**: Designed for the asynchronous Python backend (FastAPI + SQLAlchemy 2.0).

## AI Logs

Development logs and technical decisions are stored in `docs/ai/`.
