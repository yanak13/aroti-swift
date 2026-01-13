#!/bin/bash
# Deploy Aroti to k3s

set -e

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "🚀 Deploying Aroti to k3s"
echo "=========================="
echo ""

# Check if kubectl is working
if ! kubectl get nodes &> /dev/null; then
    echo "❌ kubectl not configured. Run ./setup-k3s.sh first"
    exit 1
fi

echo "✓ kubectl is configured"
echo ""

# Apply all manifests
echo "📦 Applying Kubernetes manifests..."
kubectl apply -k .

echo ""
echo "⏳ Waiting for pods to be ready..."
echo ""

# Wait for PostgreSQL
echo "Waiting for PostgreSQL..."
kubectl wait --for=condition=ready pod -l app=postgres -n aroti --timeout=120s

# Wait for Redis
echo "Waiting for Redis..."
kubectl wait --for=condition=ready pod -l app=redis -n aroti --timeout=60s

# Wait for Keycloak
echo "Waiting for Keycloak..."
kubectl wait --for=condition=ready pod -l app=keycloak -n aroti --timeout=180s

# Wait for Backend
echo "Waiting for Backend API..."
kubectl wait --for=condition=ready pod -l app=backend -n aroti --timeout=120s

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Cluster status:"
kubectl get pods -n aroti
echo ""
kubectl get services -n aroti
echo ""

# Get service URLs
echo "🌐 Access points:"
echo "  Backend API: kubectl port-forward -n aroti svc/backend 8888:8888"
echo "  Keycloak: kubectl port-forward -n aroti svc/keycloak 8080:8080"
echo "  Postgres: kubectl port-forward -n aroti svc/postgres 5432:5432"
echo "  Redis: kubectl port-forward -n aroti svc/redis 6379:6379"
echo ""
echo "To test:"
echo "  ./test-k8s.sh"
