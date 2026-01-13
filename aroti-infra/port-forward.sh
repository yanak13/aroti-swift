#!/bin/bash
# Port-forward services for local access

set -e

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "🔌 Port-forwarding Aroti services"
echo "=================================="
echo ""

# Kill any existing port-forwards
pkill -f "kubectl port-forward" || true
sleep 1

# Port-forward backend
echo "Setting up port-forwards..."
kubectl port-forward -n aroti svc/backend 8888:8888 > /dev/null 2>&1 &
echo "  ✓ Backend API: http://localhost:8888"

kubectl port-forward -n aroti svc/keycloak 8080:8080 > /dev/null 2>&1 &
echo "  ✓ Keycloak: http://localhost:8080"

kubectl port-forward -n aroti svc/postgres 5432:5432 > /dev/null 2>&1 &
echo "  ✓ PostgreSQL: localhost:5432"

kubectl port-forward -n aroti svc/redis 6379:6379 > /dev/null 2>&1 &
echo "  ✓ Redis: localhost:6379"

echo ""
echo "✅ Port-forwards active!"
echo ""
echo "Test commands:"
echo "  curl http://localhost:8888/health"
echo "  curl http://localhost:8888/docs"
echo "  open http://localhost:8080  # Keycloak"
echo ""
echo "Press Ctrl+C to stop all port-forwards"
echo ""

# Wait for interrupt
trap "echo ''; echo 'Stopping port-forwards...'; pkill -f 'kubectl port-forward'; exit 0" INT
sleep infinity
