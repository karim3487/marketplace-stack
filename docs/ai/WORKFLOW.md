# AI Development Workflow - Infrastructure (marketplace-stack)

## Phase 1: Stack Orchestration

### Generation of docker-compose.yaml

**Process**: The AI generated a standard multi-container configuration to support the Marketplace Prototype.

- **Service Selection**: Included `postgres:16-alpine` for the database and `minio/minio` for S3-compatible storage.
- **Connectivity**: Configured internal networking so `backend` can reach `postgres` and `minio` using service names as hostnames.
- **Environment**: Abstracted secrets and configurations into a `.env` file, provided via an `.env.example` template.
- **Healthchecks**: Added `healthcheck` for `postgres` (using `pg_isready`) and `minio` (using `curl`).
- **Dependencies**: Configured `backend` to use `condition: service_healthy` to ensure reliable startup order.
- **MinIO Setup**: Added `minio-setup` service using `minio/mc` to automatically create the `products` bucket and set public anonymous read policy on startup, allowing the backend to remain purely focused on business logic.

### Documentation & Setup

- **README.md**: Created a comprehensive guide for one-command deployment and multi-repo cloning.

### Volume Mapping & Persistence

**Decision**: To ensure data survival across container restarts and removals, explicit volume mapping was implemented:

- **Postgres**: mapped `./volumes/pg_data` to `/var/lib/postgresql/data`. This ensures the database state is stored on the host machine.
- **MinIO**: mapped `./volumes/minio_data` to `/data`. This ensures uploaded objects (images) are persistent.

### Port Configuration

- **Postgres**: `5432:5432` for external DB management.
- **MinIO API**: `9000:9000`.
- **MinIO Console**: `9001:9001` for web UI access.
- **Backend**: `8000:8000`.
- **Frontend**: `5173:5173` (Vite dev server).
