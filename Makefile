.PHONY: help dev dev-clean dev-restart build deploy deploy-full test clean logs status ios backend k3s-setup k3s-install k3s-uninstall port-forward

# Default target
.DEFAULT_GOAL := help

##@ General

help: ## Display this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

dev: ## Start full development environment (k3s + backend + port-forward)
	@echo "🚀 Starting development environment..."
	@$(MAKE) k3s-check || $(MAKE) k3s-install
	@$(MAKE) build
	@$(MAKE) deploy
	@$(MAKE) port-forward
	@echo "✅ Development environment ready!"
	@echo ""
	@echo "Services available at:"
	@echo "  - Backend API: http://localhost:8888"
	@echo "  - API Docs: http://localhost:8888/docs"
	@echo "  - Keycloak: http://localhost:8080"
	@echo ""
	@echo "Run 'make logs' to view logs"
	@echo "Run 'make ios' to open Xcode"

dev-clean: ## Clean and restart development environment
	@echo "🧹 Cleaning development environment..."
	@$(MAKE) clean
	@sleep 2
	@$(MAKE) dev

dev-restart: ## Restart backend services only
	@echo "🔄 Restarting backend services..."
	@kubectl rollout restart deployment/backend -n aroti
	@kubectl rollout restart deployment/backend-worker -n aroti
	@echo "✅ Services restarted"

dev-backend: ## Start backend locally (without k3s)
	@echo "🐍 Starting backend locally..."
	@cd aroti-backend && \
		if [ ! -d "venv" ]; then python3 -m venv venv; fi && \
		. venv/bin/activate && \
		pip install -q -r requirements.txt && \
		uvicorn app.main:app --reload --host 0.0.0.0 --port 8888

##@ Building

build: ## Build backend Docker image for k3s
	@echo "🐳 Building backend Docker image..."
	@cd aroti-backend && ./build-k8s.sh
	@echo "✅ Build complete"

build-force: ## Force rebuild backend image (no cache)
	@echo "🐳 Force building backend Docker image..."
	@cd aroti-backend && docker build --no-cache -t aroti/backend-api:latest .
	@docker save aroti/backend-api:latest | sudo k3s ctr images import -
	@echo "✅ Force build complete"

##@ Deployment

k3s-setup: k3s-install ## Alias for k3s-install

k3s-install: ## Install and setup k3s
	@echo "📦 Installing k3s..."
	@cd aroti-infra && sudo ./setup-k3s.sh
	@echo "✅ k3s installed"

k3s-check: ## Check if k3s is installed
	@command -v k3s >/dev/null 2>&1

deploy: ## Deploy all services to k3s
	@echo "🚀 Deploying to k3s..."
	@cd aroti-infra && ./deploy.sh
	@echo "✅ Deployment complete"

deploy-full: ## Full deployment (build + deploy)
	@$(MAKE) build
	@$(MAKE) deploy

##@ Access

port-forward: ## Start port forwarding for all services
	@echo "🔌 Starting port forwarding..."
	@echo "Press Ctrl+C to stop"
	@cd aroti-infra && ./port-forward.sh

port-forward-bg: ## Start port forwarding in background
	@echo "🔌 Starting port forwarding in background..."
	@cd aroti-infra && ./port-forward.sh &
	@echo "✅ Port forwarding started in background"
	@echo "Run 'pkill -f port-forward' to stop"

##@ Testing

test: ## Run all tests
	@echo "🧪 Running tests..."
	@cd aroti-infra/k8s && ./test-k8s.sh
	@echo ""
	@echo "Running backend tests..."
	@cd aroti-backend && python -m pytest tests/ -v || true
	@echo "✅ Tests complete"

test-api: ## Test API endpoints
	@echo "🧪 Testing API..."
	@curl -s http://localhost:8888/health | jq . || echo "❌ Health check failed"
	@curl -s http://localhost:8888/ready | jq . || echo "❌ Ready check failed"
	@echo "✅ API tests complete"

test-k8s: ## Test k8s deployment
	@cd aroti-infra && ./test-k8s.sh

##@ Monitoring

status: ## Show status of all services
	@echo "📊 Service Status"
	@echo "════════════════════════════════════════════════════════════════"
	@echo ""
	@echo "k3s Status:"
	@sudo systemctl status k3s --no-pager | head -5 || echo "k3s not installed"
	@echo ""
	@echo "Pods Status:"
	@kubectl get pods -n aroti 2>/dev/null || echo "No pods found"
	@echo ""
	@echo "Services:"
	@kubectl get svc -n aroti 2>/dev/null || echo "No services found"
	@echo ""
	@echo "Deployments:"
	@kubectl get deployments -n aroti 2>/dev/null || echo "No deployments found"

logs: ## Show logs from all services
	@cd aroti-infra && ./logs.sh all

logs-backend: ## Show backend API logs
	@cd aroti-infra && ./logs.sh backend

logs-worker: ## Show backend worker logs
	@cd aroti-infra && ./logs.sh backend-worker

logs-keycloak: ## Show Keycloak logs
	@cd aroti-infra && ./logs.sh keycloak

logs-postgres: ## Show PostgreSQL logs
	@cd aroti-infra && ./logs.sh postgres

logs-redis: ## Show Redis logs
	@cd aroti-infra && ./logs.sh redis

logs-follow: ## Follow logs from backend
	@kubectl logs -f -n aroti -l app=backend --tail=50

##@ Cleanup

clean: ## Remove all k8s resources
	@echo "🧹 Cleaning up..."
	@cd aroti-infra && ./uninstall.sh
	@echo "✅ Cleanup complete"

clean-images: ## Remove Docker images
	@echo "🧹 Removing Docker images..."
	@docker rmi aroti/backend-api:latest 2>/dev/null || true
	@sudo k3s ctr images rm docker.io/aroti/backend-api:latest 2>/dev/null || true
	@echo "✅ Images removed"

clean-all: ## Remove everything (k3s + images)
	@$(MAKE) clean
	@$(MAKE) clean-images
	@echo "🧹 Removing k3s..."
	@sudo /usr/local/bin/k3s-uninstall.sh 2>/dev/null || true
	@echo "✅ Full cleanup complete"

##@ iOS

ios: ## Open iOS project in Xcode
	@echo "📱 Opening iOS project..."
	@open aroti.xcodeproj

ios-clean: ## Clean iOS build
	@echo "🧹 Cleaning iOS build..."
	@xcodebuild clean -project aroti.xcodeproj -scheme aroti
	@echo "✅ iOS build cleaned"

ios-build: ## Build iOS project
	@echo "📱 Building iOS project..."
	@xcodebuild build -project aroti.xcodeproj -scheme aroti -destination 'platform=iOS Simulator,name=iPhone 15'
	@echo "✅ iOS build complete"

ios-test: ## Run iOS tests
	@echo "🧪 Running iOS tests..."
	@xcodebuild test -project aroti.xcodeproj -scheme aroti -destination 'platform=iOS Simulator,name=iPhone 15'
	@echo "✅ iOS tests complete"

##@ Backend

backend: dev-backend ## Start backend locally (alias)

backend-shell: ## Open shell in backend container
	@kubectl exec -it -n aroti deployment/backend -- /bin/sh

backend-migrate: ## Run database migrations
	@echo "🔄 Running migrations..."
	@kubectl exec -it -n aroti deployment/backend -- alembic upgrade head
	@echo "✅ Migrations complete"

backend-lint: ## Lint backend code
	@echo "🔍 Linting backend..."
	@cd aroti-backend && \
		. venv/bin/activate && \
		black --check app/ && \
		flake8 app/ || true
	@echo "✅ Linting complete"

backend-format: ## Format backend code
	@echo "✨ Formatting backend..."
	@cd aroti-backend && \
		. venv/bin/activate && \
		black app/
	@echo "✅ Formatting complete"

##@ Database

db-shell: ## Open PostgreSQL shell
	@echo "🗄️  Opening database shell..."
	@kubectl exec -it -n aroti deployment/postgres -- psql -U postgres -d aroti

db-backup: ## Backup database
	@echo "💾 Backing up database..."
	@kubectl exec -n aroti deployment/postgres -- pg_dump -U postgres aroti > backup-$$(date +%Y%m%d-%H%M%S).sql
	@echo "✅ Backup complete"

db-reset: ## Reset database (WARNING: destructive)
	@echo "⚠️  This will delete all data. Press Ctrl+C to cancel, or Enter to continue..."
	@read
	@kubectl exec -it -n aroti deployment/postgres -- psql -U postgres -c "DROP DATABASE IF EXISTS aroti;"
	@kubectl exec -it -n aroti deployment/postgres -- psql -U postgres -c "CREATE DATABASE aroti;"
	@$(MAKE) backend-migrate
	@echo "✅ Database reset complete"

##@ Utilities

watch: ## Watch pod status
	@watch -n 2 kubectl get pods -n aroti

pods: ## List all pods
	@kubectl get pods -n aroti

events: ## Show recent events
	@kubectl get events -n aroti --sort-by='.lastTimestamp'

describe-backend: ## Describe backend deployment
	@kubectl describe deployment/backend -n aroti

scale-backend: ## Scale backend (usage: make scale-backend REPLICAS=3)
	@kubectl scale deployment/backend -n aroti --replicas=$(or $(REPLICAS),2)
	@echo "✅ Backend scaled to $(or $(REPLICAS),2) replicas"

restart: dev-restart ## Restart services (alias)

##@ Documentation

docs: ## Open documentation in browser
	@echo "📚 Opening documentation..."
	@open README.md
	@open docs/K3S_START_HERE.md
	@open docs/QUICK_REFERENCE.md

docs-api: ## Open API documentation
	@echo "📖 Opening API docs..."
	@open http://localhost:8888/docs

##@ Quick Actions

quick-start: k3s-install build deploy port-forward ## Complete setup from scratch
	@echo ""
	@echo "════════════════════════════════════════════════════════════════"
	@echo "✅ Quick start complete!"
	@echo "════════════════════════════════════════════════════════════════"
	@echo ""
	@echo "Services:"
	@echo "  - Backend API: http://localhost:8888"
	@echo "  - API Docs: http://localhost:8888/docs"
	@echo "  - Keycloak: http://localhost:8080"
	@echo ""
	@echo "Next steps:"
	@echo "  - Run 'make ios' to open Xcode"
	@echo "  - Run 'make logs' to view logs"
	@echo "  - Run 'make status' to check status"
	@echo ""

rebuild: ## Quick rebuild and redeploy
	@$(MAKE) build
	@$(MAKE) dev-restart
	@echo "✅ Rebuild complete"

reset: ## Reset everything and start fresh
	@echo "⚠️  This will reset everything. Press Ctrl+C to cancel, or Enter to continue..."
	@read
	@$(MAKE) clean
	@$(MAKE) quick-start

##@ Information

version: ## Show versions
	@echo "Versions:"
	@echo "  k3s: $$(k3s --version 2>/dev/null | head -1 || echo 'not installed')"
	@echo "  kubectl: $$(kubectl version --client --short 2>/dev/null || echo 'not installed')"
	@echo "  docker: $$(docker --version 2>/dev/null || echo 'not installed')"
	@echo "  python: $$(python3 --version 2>/dev/null || echo 'not installed')"
	@echo "  xcodebuild: $$(xcodebuild -version 2>/dev/null | head -1 || echo 'not installed')"

check: ## Check prerequisites
	@echo "Checking prerequisites..."
	@command -v k3s >/dev/null 2>&1 && echo "✓ k3s installed" || echo "✗ k3s not installed"
	@command -v kubectl >/dev/null 2>&1 && echo "✓ kubectl installed" || echo "✗ kubectl not installed"
	@command -v docker >/dev/null 2>&1 && echo "✓ docker installed" || echo "✗ docker not installed"
	@command -v python3 >/dev/null 2>&1 && echo "✓ python3 installed" || echo "✗ python3 not installed"
	@command -v xcodebuild >/dev/null 2>&1 && echo "✓ xcodebuild installed" || echo "✗ xcodebuild not installed"
