# Aroti Kubernetes Manifests

Kubernetes manifests for deploying Aroti to k3s.

## Quick Start

```bash
# 1. Setup k3s
sudo ./setup-k3s.sh

# 2. Build backend image
cd ../aroti-backend && ./build-k8s.sh

# 3. Deploy
cd ../aroti-infra && ./deploy.sh

# 4. Access services
./port-forward.sh
```

## What's Included

- **PostgreSQL 15** - Database with persistent storage
- **Redis 7** - Cache layer
- **Keycloak 26** - Authentication and identity provider
- **Backend API** - FastAPI application (2 replicas)
- **Backend Worker** - Temporal workflow worker
- **Ingress** - HTTP routing (optional)

## Scripts

| Script | Purpose |
|--------|---------|
| `setup-k3s.sh` | Install and configure k3s |
| `deploy.sh` | Deploy all resources to k3s |
| `test-k8s.sh` | Test the deployment |
| `port-forward.sh` | Port-forward services to localhost |
| `logs.sh` | View logs from services |
| `uninstall.sh` | Remove all resources |

## Configuration

All configuration is stored in:
- **ConfigMaps**: Non-sensitive configuration
- **Secrets**: Passwords and sensitive data

No `.env` files are used - everything is Kubernetes-native.

### ConfigMaps

- `backend/backend-configmap.yaml` - API configuration
- `database/postgres-configmap.yaml` - Database config
- `keycloak/keycloak-configmap.yaml` - Auth config

### Secrets

- `database/postgres-secret.yaml` - Database password
- `keycloak/keycloak-secret.yaml` - Keycloak admin password

## Accessing Services

With port-forwarding:
- **API**: http://localhost:8888
- **API Docs**: http://localhost:8888/docs
- **Keycloak**: http://localhost:8080
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

## Testing

```bash
# Run automated tests
./test-k8s.sh

# Manual testing
curl http://localhost:8888/health
curl http://localhost:8888/ready
```

## Development

```bash
# Update code
cd ../aroti-backend
# Make changes...

# Rebuild and restart
./build-k8s.sh
kubectl rollout restart deployment/backend -n aroti
```

## Troubleshooting

```bash
# Check pods
kubectl get pods -n aroti

# Check logs
./logs.sh backend

# Describe resources
kubectl describe pod <pod-name> -n aroti

# Events
kubectl get events -n aroti
```

## Full Documentation

See: `../docs/K3S_SETUP.md` for complete guide

## Production

For production deployment:
1. Update secrets with strong passwords
2. Use specific image tags (not `latest`)
3. Configure proper ingress with TLS
4. Add monitoring and alerting
5. Configure backups
