# Aroti Documentation

## Documentation Index

### Architecture Documentation

1. **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Complete backend architecture
   - System overview
   - Backend architecture details
   - Infrastructure architecture
   - Data flow diagrams
   - Authentication flow
   - Deployment architecture

2. **[FRONTEND_COMMUNICATION.md](./FRONTEND_COMMUNICATION.md)** - Frontend communication guide
   - iOS app architecture
   - Authentication flow
   - API request/response patterns
   - Error handling
   - Caching strategy
   - Best practices

### Infrastructure Documentation

See `aroti-infra/docs/` for infrastructure-specific documentation:

- **[ARCHITECTURE.md](../aroti-infra/docs/ARCHITECTURE.md)** - Infrastructure architecture
- **[DEPLOYMENT_GUIDE.md](../aroti-infra/docs/DEPLOYMENT_GUIDE.md)** - Deployment instructions
- **[KEYCLOAK_CONFIGURATION.md](../aroti-infra/docs/KEYCLOAK_CONFIGURATION.md)** - Keycloak setup
- **[SECRET_MANAGEMENT_GUIDE.md](../aroti-infra/docs/SECRET_MANAGEMENT_GUIDE.md)** - Secrets management

## Quick Start

### For Developers

1. **Backend Development**: See [README.md](../README.md)
2. **Frontend Integration**: See [FRONTEND_COMMUNICATION.md](./FRONTEND_COMMUNICATION.md)
3. **Architecture Overview**: See [ARCHITECTURE.md](./ARCHITECTURE.md)

### For DevOps

1. **Infrastructure Setup**: See `aroti-infra/docs/DEPLOYMENT_GUIDE.md`
2. **Architecture**: See `aroti-infra/docs/ARCHITECTURE.md`
3. **Secrets**: See `aroti-infra/docs/SECRET_MANAGEMENT_GUIDE.md`

## Key Concepts

### Authentication Flow

1. iOS app initiates OAuth PKCE flow with Keycloak
2. User authenticates with Keycloak
3. Keycloak returns access + refresh tokens
4. Tokens stored in iOS Keychain
5. All API requests include JWT token
6. Backend validates token with Keycloak JWK
7. Tokens automatically refreshed when needed

### Request Flow

1. Controller initiates request
2. Check local cache (memory → disk)
3. If cache miss, make API request
4. Backend checks Redis cache
5. If cache miss, query PostgreSQL
6. Store in both caches
7. Return response to controller
8. Update UI

### Caching Strategy

- **iOS**: Two-tier (memory + disk), 5 min TTL
- **Backend**: Redis, 30 min - 1 hour TTL
- **Invalidation**: On data updates

## Architecture Diagrams

All diagrams use Mermaid syntax and can be viewed in:
- GitHub (rendered automatically)
- VS Code (with Mermaid extension)
- Online: https://mermaid.live

## Contributing

When adding new features:

1. Update relevant architecture diagrams
2. Document new endpoints in FRONTEND_COMMUNICATION.md
3. Update API documentation
4. Add tests for new functionality
