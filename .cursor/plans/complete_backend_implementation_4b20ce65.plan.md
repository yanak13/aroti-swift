---
name: Complete Backend Implementation
overview: Implement the complete Python FastAPI backend application, database layer, Docker containerization, Temporal workflows, and enhance iOS app with OAuth/token refresh capabilities.
todos:
  - id: backend-project-structure
    content: Create aroti-backend/ directory structure with app/, tests/, alembic/ folders and base files
    status: completed
  - id: backend-core-app
    content: Implement FastAPI application (main.py, config.py, database.py, dependencies.py)
    status: in_progress
  - id: backend-models
    content: Create SQLAlchemy models (specialist.py, session.py, user.py, review.py, profile.py)
    status: pending
  - id: backend-schemas
    content: Create Pydantic schemas matching iOS models (booking.py, profile.py, home.py)
    status: pending
  - id: backend-auth
    content: Implement Keycloak JWT validation (auth/keycloak.py)
    status: pending
  - id: backend-cache
    content: Implement Redis caching layer (cache/redis_client.py)
    status: pending
  - id: backend-api-routes
    content: Implement all API route handlers (specialists, sessions, profile, daily_insights, health)
    status: pending
  - id: backend-migrations
    content: Create Alembic migrations (initial schema + seed data)
    status: pending
  - id: backend-dockerfile
    content: Create Dockerfile, requirements.txt, and build.sh script
    status: pending
  - id: backend-docker-compose
    content: Create docker-compose.yml for local development
    status: pending
  - id: temporal-workflows
    content: Implement Temporal workflows (session_booking.py, worker.py)
    status: pending
  - id: temporal-worker-deployment
    content: Create Kubernetes deployment for Temporal worker
    status: pending
  - id: ios-oauth-service
    content: Implement KeycloakAuthService.swift with PKCE flow
    status: pending
  - id: ios-token-refresh
    content: Enhance AuthManager.swift with token refresh methods
    status: pending
  - id: ios-api-auto-refresh
    content: Add automatic retry with token refresh to APIClient.swift
    status: pending
  - id: ios-auth-views
    content: Create LoginView.swift and AuthController.swift
    status: pending
  - id: ios-environment-config
    content: Add debug/production environment switching to APIConfiguration.swift
    status: pending
  - id: backend-tests
    content: Create backend test suite (unit tests for models, auth, cache; integration tests for API)
    status: pending
  - id: backend-docs
    content: Create backend README.md with setup and development instructions
    status: pending
  - id: cicd-backend-build
    content: Create GitHub Actions workflow for backend build and deployment
    status: pending
  - id: k8s-init-container
    content: Add migration init container to backend deployment YAML
    status: pending
  - id: ios-tests-auth
    content: Add tests for OAuth flow and token refresh in iOS app
    status: pending
---

