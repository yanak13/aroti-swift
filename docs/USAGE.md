# Usage Guide

Daily development and operations guide.

## Quick Reference

```bash
# Start everything
make dev

# Open iOS
make ios

# View logs
make logs-follow

# Check status
make status

# Stop everything
make clean
```

## Development Workflow

### Starting Development

```bash
# Option 1: Using Makefile (recommended)
make dev

# Option 2: Manual
cd aroti-infra
./deploy.sh
./port-forward.sh
```

Services will be available at:
- Backend: http://localhost:8888
- Keycloak: http://localhost:8080

### iOS Development

```bash
# Open Xcode
make ios

# Build
make ios-build

# Run tests
make ios-test

# Clean build
make ios-clean
```

Or use Xcode directly:
```bash
open aroti.xcodeproj
```

### Backend Development

#### Local Development (without k3s)

```bash
make backend
# or
cd aroti-backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

#### After Code Changes

```bash
# Quick rebuild and restart
make rebuild

# Or manually
cd aroti-backend
./build-k8s.sh
make restart
```

#### Database Migrations

```bash
# Run migrations
make backend-migrate

# Or manually
kubectl exec -it -n aroti deployment/backend -- alembic upgrade head
```

## Makefile Commands

### Development

| Command | Description |
|---------|-------------|
| `make dev` | Start full dev environment |
| `make dev-clean` | Clean and restart |
| `make dev-restart` | Restart services only |

### Building

| Command | Description |
|---------|-------------|
| `make build` | Build backend image |
| `make rebuild` | Quick rebuild + restart |

### Monitoring

| Command | Description |
|---------|-------------|
| `make status` | Show service status |
| `make logs` | View all logs |
| `make logs-backend` | Backend logs only |
| `make logs-follow` | Follow logs in real-time |
| `make watch` | Watch pod status |

### Testing

| Command | Description |
|---------|-------------|
| `make test` | Run all tests |
| `make test-api` | Test API endpoints |

### iOS

| Command | Description |
|---------|-------------|
| `make ios` | Open Xcode |
| `make ios-build` | Build iOS app |
| `make ios-test` | Run iOS tests |

### Database

| Command | Description |
|---------|-------------|
| `make db-shell` | Open PostgreSQL shell |
| `make db-backup` | Backup database |

### Cleanup

| Command | Description |
|---------|-------------|
| `make clean` | Remove k8s resources |
| `make clean-all` | Full cleanup |

### Utilities

| Command | Description |
|---------|-------------|
| `make pods` | List all pods |
| `make events` | Show recent events |
| `make scale-backend REPLICAS=3` | Scale backend |

## Common Tasks

### View Logs

```bash
# Follow backend logs in real-time
make logs-follow

# View all logs
make logs

# Specific service
make logs-backend
make logs-worker
make logs-keycloak
make logs-postgres
make logs-redis
```

### Check Status

```bash
# Overview
make status

# List pods
make pods
# or
kubectl get pods -n aroti

# Describe pod
kubectl describe pod <pod-name> -n aroti

# Watch status
make watch
```

### Restart Services

```bash
# Restart all backend services
make restart

# Restart specific deployment
kubectl rollout restart deployment/backend -n aroti
kubectl rollout restart deployment/backend-worker -n aroti
```

### Scale Services

```bash
# Scale backend to 3 replicas
make scale-backend REPLICAS=3

# Scale back to 2
make scale-backend REPLICAS=2
```

### Access Database

```bash
# Open PostgreSQL shell
make db-shell

# Or manually
kubectl exec -it -n aroti deployment/postgres -- psql -U postgres -d aroti

# Backup database
make db-backup

# Output: backup-YYYYMMDD-HHMMSS.sql
```

### Access Backend Container

```bash
# Open shell in backend pod
make backend-shell

# Or manually
kubectl exec -it -n aroti deployment/backend -- /bin/sh
```

### Test API

```bash
# Health check
curl http://localhost:8888/health

# Ready check
curl http://localhost:8888/ready

# View API docs
open http://localhost:8888/docs

# Or use make command
make docs-api
```

## Typical Development Day

### Morning Setup

```bash
# Start everything
make dev

# In another terminal, open iOS
make ios

# In another terminal, watch logs
make logs-follow
```

### During Development

```bash
# After backend changes
make rebuild

# Check if everything is working
make status
make test-api

# View logs for debugging
make logs-backend
```

### End of Day

```bash
# Optional: Stop everything to free resources
make clean

# Or just leave it running for tomorrow
# k3s is lightweight and won't use much resources
```

## Testing

### Backend Tests

```bash
# Run backend tests
cd aroti-backend
pytest tests/ -v

# Or from root
make test
```

### iOS Tests

```bash
# From Xcode
Cmd+U

# Or from command line
make ios-test
```

### API Testing

```bash
# Use API docs
open http://localhost:8888/docs

# Or curl
curl -X GET http://localhost:8888/api/specialists
curl -X GET http://localhost:8888/api/sessions
```

## Debugging

### Backend Issues

```bash
# View logs
make logs-backend

# Check pod status
kubectl describe pod -l app=backend -n aroti

# Check events
kubectl get events -n aroti

# Access container
make backend-shell
```

### iOS Issues

```bash
# Check API connectivity
curl http://localhost:8888/health

# Verify port forwarding is running
lsof -ti:8888

# Check Keycloak
open http://localhost:8080
```

### Database Issues

```bash
# Check PostgreSQL logs
make logs-postgres

# Access database
make db-shell

# Check connection from backend
kubectl exec -it -n aroti deployment/backend -- env | grep DATABASE
```

## Configuration Changes

### Update Backend Configuration

Edit `aroti-infra/backend/backend-configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backend-config
data:
  DATABASE_URL: "postgresql://postgres:postgres@postgres:5432/aroti"
  REDIS_HOST: "redis"
  # ... other config
```

Apply changes:
```bash
kubectl apply -f aroti-infra/backend/backend-configmap.yaml
make restart
```

### Update Secrets

Edit `aroti-infra/database/postgres-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secret
stringData:
  POSTGRES_PASSWORD: "your-new-password"
```

Apply and restart:
```bash
kubectl apply -f aroti-infra/database/postgres-secret.yaml
kubectl rollout restart deployment/postgres -n aroti
```

## Performance

### Check Resource Usage

```bash
# Pod resource usage
kubectl top pods -n aroti

# Node resource usage
kubectl top nodes
```

### Scale for Performance

```bash
# Scale backend for more throughput
make scale-backend REPLICAS=5

# Check status
make status
```

## Cleanup

### Remove Aroti Resources

```bash
# Remove all Aroti resources
make clean

# Verify cleanup
kubectl get all -n aroti
# Should show: No resources found
```

### Full Cleanup (Including k3s)

```bash
# Remove everything including k3s
make clean-all

# This will:
# - Delete all k8s resources
# - Remove Docker images
# - Uninstall k3s
```

### Start Fresh

```bash
# Clean and restart
make dev-clean

# Or completely fresh install
make clean-all
make quick-start
```

## Tips

1. **Keep port-forward running** - Run it in a dedicated terminal
2. **Watch logs during dev** - Use `make logs-follow` in another terminal
3. **Check status often** - Quick `make status` before starting work
4. **Use Makefile** - Easier than remembering kubectl commands
5. **Clean when stuck** - `make dev-clean` solves most issues

## Help

```bash
# See all available commands
make help

# Check prerequisites
make check

# Show versions
make version
```

## Summary

**Daily workflow:**
```bash
make dev          # Start
make ios          # Develop
make logs-follow  # Monitor
make rebuild      # After changes
make clean        # End of day (optional)
```

**When things go wrong:**
```bash
make status       # Check what's wrong
make logs         # See errors
make restart      # Try restart
make dev-clean    # Full reset
```

That's it! Keep it simple.
