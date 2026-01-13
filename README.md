# Aroti

A mental health and therapy platform with iOS app and backend infrastructure.

## Project Structure

```
aroti-swift/
├── aroti/              # iOS app (Swift/SwiftUI)
├── aroti-backend/      # Python FastAPI backend
├── aroti-infra/        # Infrastructure & Kubernetes manifests
├── docs/               # Documentation
├── arotiTests/         # iOS unit tests
└── arotiUITests/       # iOS UI tests
```

## Quick Start

```bash
# Complete setup from scratch
make quick-start

# Daily development
make dev

# Open iOS app
make ios

# See all commands
make help
```

For detailed instructions, see [SETUP.md](docs/SETUP.md).

## Documentation

- **[SETUP.md](docs/SETUP.md)** - Installation and configuration
- **[USAGE.md](docs/USAGE.md)** - Daily development and operations

## Components

- **iOS App** (`aroti/`) - SwiftUI app with OAuth authentication
- **Backend API** (`aroti-backend/`) - Python FastAPI with PostgreSQL
- **Infrastructure** (`aroti-infra/`) - Kubernetes manifests and scripts

## Daily Development

```bash
make dev          # Start everything
make ios          # Open Xcode
make logs-follow  # Monitor logs
make status       # Check status
```

See [USAGE.md](docs/USAGE.md) for complete workflow guide.

## Access Points

After running `make dev`:
- Backend API: http://localhost:8888
- API Docs: http://localhost:8888/docs
- Keycloak: http://localhost:8080

## Key Features

- OAuth 2.0 PKCE authentication
- Kubernetes-native (no .env files)
- Comprehensive Makefile (50+ commands)
- Local k3s development
- Automated deployment

## Support

See documentation in [docs/](docs/) directory.
