# Aroti Backend Quickstart Guide

## Prerequisites

- Docker Desktop installed and running
- Python 3.11+ installed
- macOS, Linux, or Windows with WSL2

## Quick Start (5 minutes)

### 1. Clone and Setup

```bash
cd aroti-backend

# Run automated setup (installs dependencies and starts services)
./setup.sh
```

This script will:
- ✓ Check Docker is installed and running
- ✓ Create Python virtual environment
- ✓ Install Python dependencies
- ✓ Start PostgreSQL, Redis, and Keycloak containers
- ✓ Run database migrations
- ✓ Seed sample data

### 2. Start API Server

```bash
./start.sh
```

The API will be available at:
- **API**: http://localhost:8888
- **API Docs**: http://localhost:8888/docs (Swagger UI)
- **ReDoc**: http://localhost:8888/redoc

### 3. Test API

In a new terminal:

```bash
./test-api.sh
```

### 4. Access Services

- **Keycloak Admin**: http://localhost:8080 (admin/admin)
- **PostgreSQL**: `psql -h localhost -U postgres -d aroti_dev` (password: dev_password)
- **Redis**: `redis-cli -p 6379`

## Manual Testing

### Test Health Endpoint

```bash
curl http://localhost:8888/health
# Response: {"status":"healthy"}
```

### Test Readiness Endpoint

```bash
curl http://localhost:8888/ready
# Response: {"status":"ready","checks":{"database":true,"redis":true}}
```

### Get Specialists (Requires Auth)

Without authentication:
```bash
curl http://localhost:8888/api/specialists
# Response: 401 Unauthorized
```

With authentication (see Keycloak setup below):
```bash
curl -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  http://localhost:8888/api/specialists
```

## Keycloak Configuration

### 1. Access Keycloak Admin Console

1. Open http://localhost:8080
2. Click "Administration Console"
3. Login: admin / admin

### 2. Create Realm

1. Click dropdown next to "master" realm
2. Click "Create Realm"
3. Name: `aroti`
4. Click "Create"

### 3. Create Client

1. In "aroti" realm, go to "Clients"
2. Click "Create client"
3. Configure:
   - **Client ID**: `aroti-ios`
   - **Client type**: Public
   - Click "Next"
4. Capability config:
   - Enable "Standard flow"
   - Enable "Direct access grants"
   - Click "Next"
5. Login settings:
   - **Valid redirect URIs**: `com.aroti.app://oauth/callback`
   - **Valid post logout redirect URIs**: `com.aroti.app://`
   - **Web origins**: `*`
6. Click "Save"

### 4. Create Test User

1. Go to "Users"
2. Click "Create new user"
3. Username: `testuser`
4. Click "Create"
5. Go to "Credentials" tab
6. Click "Set password"
7. Password: `testpass123`
8. Temporary: OFF
9. Click "Save"

### 5. Get JWT Token (For Testing)

```bash
curl -X POST http://localhost:8080/realms/aroti/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "client_id=aroti-ios" \
  -d "username=testuser" \
  -d "password=testpass123" \
  -d "grant_type=password"
```

Save the `access_token` from the response.

### 6. Test Authenticated Request

```bash
export TOKEN="your_access_token_here"

curl -H "Authorization: Bearer $TOKEN" \
  http://localhost:8888/api/specialists
```

## Development Workflow

### Making Changes

1. Edit files in `app/`
2. Server auto-reloads (if started with `./start.sh`)
3. Test changes at http://localhost:8888/docs

### Database Changes

```bash
# Create new migration
alembic revision --autogenerate -m "description"

# Apply migrations
alembic upgrade head

# Rollback migration
alembic downgrade -1
```

### Running Tests

```bash
source venv/bin/activate
pytest
```

### View Logs

```bash
# API logs (if running with ./start.sh, logs appear in terminal)

# Docker service logs
docker-compose logs postgres
docker-compose logs redis
docker-compose logs keycloak
```

## Troubleshooting

### Port Already in Use

```bash
# Check what's using port 8888
lsof -i :8888

# Kill process
kill -9 <PID>
```

### Database Connection Error

```bash
# Restart PostgreSQL
docker-compose restart postgres

# Check logs
docker-compose logs postgres
```

### Redis Connection Error

```bash
# Restart Redis
docker-compose restart redis

# Test connection
docker-compose exec redis redis-cli ping
```

### Reset Everything

```bash
# Stop all services
docker-compose down -v

# Remove database volumes
docker volume prune

# Start fresh
./setup.sh
```

## Next Steps

1. **iOS App Integration**: Configure iOS app to use `http://localhost:8888`
2. **Add Data**: Use `/docs` endpoint to add more specialists/sessions
3. **Temporal Workflows**: Run worker with `python -m app.workflows.worker`
4. **Production Deploy**: See `README.md` for Kubernetes deployment

## Support

- API Documentation: http://localhost:8888/docs
- Full README: `README.md`
- Homebrew Setup: `SETUP_HOMEBREW.md`
