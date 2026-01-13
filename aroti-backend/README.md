# Aroti Backend API

FastAPI backend application for the Aroti iOS app.

## Features

- FastAPI REST API
- PostgreSQL database with SQLAlchemy ORM
- Redis caching layer
- Keycloak JWT authentication
- Temporal workflows for async processing
- Docker containerization
- Alembic database migrations

## Prerequisites

- Python 3.11+
- PostgreSQL 15+
- Redis 7+
- Docker and Docker Compose (for local development)

## Local Development Setup

### Using Docker Compose (Recommended)

1. **Start all services:**
   ```bash
   docker-compose up -d
   ```

2. **Run database migrations:**
   ```bash
   docker-compose exec api alembic upgrade head
   ```

3. **Access services:**
   - API: http://localhost:8888
   - Keycloak: http://localhost:8080
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

4. **View API documentation:**
   - Swagger UI: http://localhost:8888/docs
   - ReDoc: http://localhost:8888/redoc

### Manual Setup

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Set environment variables:**
   ```bash
   export DATABASE_URL="postgresql://postgres:password@localhost:5432/aroti_dev"
   export REDIS_HOST="localhost"
   export KEYCLOAK_ISSUER_URI="http://localhost:8080/realms/aroti"
   ```

3. **Run migrations:**
   ```bash
   alembic upgrade head
   ```

4. **Start server:**
   ```bash
   uvicorn app.main:app --reload
   ```

## Keycloak Configuration

1. Access Keycloak admin console: http://localhost:8080
2. Login with admin/admin
3. Create realm "aroti"
4. Create client "aroti-ios" with:
   - Client ID: `aroti-ios`
   - Access Type: `public`
   - Valid Redirect URIs: `com.aroti.app://oauth/callback`
   - Web Origins: `*` (for development)

## API Endpoints

### Health Checks
- `GET /health` - Simple health check
- `GET /ready` - Readiness check (database + Redis)

### Specialists
- `GET /api/specialists` - List specialists (with filters)
- `GET /api/specialists/{id}` - Get specialist details
- `GET /api/reviews/{specialist_id}` - Get reviews for specialist

### Sessions
- `GET /api/sessions` - Get user's sessions
- `GET /api/sessions/{id}` - Get session details
- `POST /api/sessions` - Book a new session
- `PUT /api/sessions/{id}` - Update session
- `DELETE /api/sessions/{id}` - Cancel session

### Profile
- `GET /api/user/profile` - Get user profile
- `PUT /api/user/profile` - Update user profile
- `DELETE /api/user/account` - Delete account

### Daily Insights
- `GET /api/daily-insights` - Get daily insights (tarot, horoscope, etc.)

## Authentication

All API endpoints (except `/health` and `/ready`) require authentication via JWT token:

```
Authorization: Bearer <access_token>
```

Tokens are obtained through Keycloak OAuth PKCE flow (handled by iOS app).

## Database Migrations

### Create a new migration:
```bash
alembic revision --autogenerate -m "description"
```

### Apply migrations:
```bash
alembic upgrade head
```

### Rollback migration:
```bash
alembic downgrade -1
```

## Testing

Run tests:
```bash
pytest
```

Run with coverage:
```bash
pytest --cov=app --cov-report=html
```

## Docker Build

Build Docker image:
```bash
./build.sh [version]
```

Default version is `latest`.

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://postgres:postgres@localhost:5432/aroti` |
| `REDIS_HOST` | Redis host | `localhost` |
| `REDIS_PORT` | Redis port | `6379` |
| `KEYCLOAK_ISSUER_URI` | Keycloak issuer URI | `http://localhost:8080/realms/aroti` |
| `KEYCLOAK_AUDIENCE` | JWT audience | `aroti-app` |
| `API_PORT` | API server port | `8888` |
| `API_DEBUG` | Enable debug mode | `false` |
| `CORS_ORIGINS` | Allowed CORS origins (comma-separated) | `http://localhost:3000,com.aroti.app://` |

## Temporal Workflows

Temporal workflows are defined in `app/workflows/`. To run the worker:

```bash
python -m app.workflows.worker
```

The worker connects to Temporal server and executes workflows/activities.

## Project Structure

```
aroti-backend/
├── app/
│   ├── api/          # API route handlers
│   ├── auth/         # Authentication (Keycloak JWT)
│   ├── cache/        # Redis caching
│   ├── models/       # SQLAlchemy models
│   ├── schemas/      # Pydantic schemas
│   ├── workflows/    # Temporal workflows
│   ├── config.py     # Configuration
│   ├── database.py   # Database setup
│   └── main.py       # FastAPI app
├── alembic/          # Database migrations
├── tests/            # Test suite
├── Dockerfile
├── docker-compose.yml
└── requirements.txt
```

## Troubleshooting

### Database connection errors
- Ensure PostgreSQL is running
- Check `DATABASE_URL` environment variable
- Verify database exists: `createdb aroti_dev`

### Redis connection errors
- Ensure Redis is running: `redis-cli ping`
- Check `REDIS_HOST` and `REDIS_PORT` environment variables

### Keycloak authentication errors
- Verify Keycloak is running and realm is configured
- Check `KEYCLOAK_ISSUER_URI` matches your Keycloak setup
- Ensure client is properly configured

## License

Proprietary - Aroti
