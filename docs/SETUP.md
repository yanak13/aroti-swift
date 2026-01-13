# Setup Guide

Complete setup instructions for Aroti.

## Prerequisites

- macOS or Linux
- Docker Desktop installed and running
- Python 3.9+
- Xcode (for iOS development)
- sudo access

## Quick Setup

```bash
# From project root
make quick-start
```

This will:
1. Install k3s
2. Build backend Docker image
3. Deploy all services
4. Start port forwarding

Done! Skip to [Verify Setup](#verify-setup) below.

## Manual Setup

### 1. Install k3s

```bash
cd aroti-infra
sudo ./setup-k3s.sh
```

Verifies:
- k3s installed
- kubectl configured

### 2. Build Backend

```bash
cd ../aroti-backend
./build-k8s.sh
```

Creates and imports Docker image to k3s.

### 3. Deploy Services

```bash
cd ../aroti-infra
./deploy.sh
```

Deploys:
- PostgreSQL (database)
- Redis (cache)
- Keycloak (auth)
- Backend API (2 replicas)
- Backend Worker (Temporal)

Wait ~2 minutes for all pods to be ready.

### 4. Access Services

```bash
./port-forward.sh
```

Keep this running. Services available at:
- Backend API: http://localhost:8888
- Keycloak: http://localhost:8080
- PostgreSQL: localhost:5432
- Redis: localhost:6379

## Verify Setup

### Check Pods

```bash
make status
# or
kubectl get pods -n aroti
```

All pods should show `Running` status.

### Test API

```bash
# Health check
curl http://localhost:8888/health
# Should return: {"status":"healthy"}

# API docs
open http://localhost:8888/docs
```

### Test Keycloak

```bash
open http://localhost:8080
```

Default admin credentials:
- Username: `admin`
- Password: `admin` (change in production!)

### Run iOS App

```bash
make ios
# or
open aroti.xcodeproj
```

Build and run in Xcode simulator.

## Configuration

### Keycloak Setup (First Time)

1. Open http://localhost:8080
2. Login with admin/admin
3. Create realm: `aroti`
4. Create client: `aroti-ios`
   - Client Protocol: `openid-connect`
   - Access Type: `public`
   - Valid Redirect URIs: `aroti://oauth/callback`
   - Enable PKCE

### iOS Configuration

Debug mode automatically uses `localhost`:
- API: http://localhost:8888
- Keycloak: http://localhost:8080

For production, update `aroti/Utilities/APIConfiguration.swift`:

```swift
#if DEBUG
static let baseURL = "http://localhost:8888"
static let keycloakURL = "http://localhost:8080"
#else
static let baseURL = "https://api.aroti.com"
static let keycloakURL = "https://auth.aroti.com"
#endif
```

## Troubleshooting

### Pods Not Starting

```bash
# Check pod status
kubectl get pods -n aroti

# View logs
make logs-backend

# Check events
kubectl get events -n aroti

# Restart
make restart
```

### Port Already in Use

```bash
# Kill existing port forwards
pkill -f port-forward

# Or kill specific port
lsof -ti:8888 | xargs kill -9

# Restart port forwarding
make port-forward
```

### Image Not Found

```bash
# Rebuild image
cd aroti-backend
./build-k8s.sh

# Verify import
sudo k3s ctr images ls | grep aroti
```

### k3s Issues

```bash
# Check k3s status
sudo systemctl status k3s

# Restart k3s
sudo systemctl restart k3s

# Reinstall
sudo /usr/local/bin/k3s-uninstall.sh
cd aroti-infra
sudo ./setup-k3s.sh
```

### Clean Start

```bash
# Remove everything and start fresh
make clean
make quick-start
```

## Environment-Specific Notes

### Local Development

All services run in local k3s:
- No .env files needed
- Configuration in Kubernetes ConfigMaps/Secrets
- Port forwarding required for access

### Production

For production deployment:
1. Update secrets with strong passwords
2. Use specific image tags (not `latest`)
3. Configure proper ingress with TLS
4. Set up monitoring
5. Configure backups
6. Update Keycloak redirect URIs

## What Gets Installed

### k3s Components
- Lightweight Kubernetes distribution
- Local container registry
- Basic networking

### Application Services
- PostgreSQL 15 (database)
- Redis 7 (cache)
- Keycloak 26 (authentication)
- Backend API (FastAPI)
- Backend Worker (Temporal)

### Storage
- PostgreSQL: 1Gi persistent volume
- Redis: In-memory (ephemeral)

### Networking
- All services in `aroti` namespace
- ClusterIP services (internal)
- Port forwarding for local access
- Ingress rules (optional)

## Next Steps

After setup:
1. Configure Keycloak realm and client
2. Test API endpoints via http://localhost:8888/docs
3. Run iOS app in Xcode
4. View logs: `make logs-follow`
5. Monitor status: `make status`

See [USAGE.md](USAGE.md) for daily development workflow.
