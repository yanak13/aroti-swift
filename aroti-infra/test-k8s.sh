#!/bin/bash
# Test Aroti deployment in k3s

set -e

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "🧪 Testing Aroti k3s Deployment"
echo "================================"
echo ""

# Check if deployment exists
if ! kubectl get namespace aroti &> /dev/null; then
    echo "❌ Aroti namespace not found. Run ./deploy.sh first"
    exit 1
fi

echo "1. Checking pod status..."
kubectl get pods -n aroti
echo ""

echo "2. Checking services..."
kubectl get services -n aroti
echo ""

# Port forward to backend
echo "3. Testing backend API..."
echo "   Setting up port-forward..."
kubectl port-forward -n aroti svc/backend 8888:8888 > /dev/null 2>&1 &
PF_PID=$!
sleep 3

# Test health endpoint
echo "   Testing /health endpoint..."
if curl -s http://localhost:8888/health | grep -q "healthy"; then
    echo "   ✓ Health check passed"
else
    echo "   ❌ Health check failed"
fi

# Test ready endpoint
echo "   Testing /ready endpoint..."
response=$(curl -s http://localhost:8888/ready)
if echo "$response" | grep -q "ready"; then
    echo "   ✓ Ready check passed"
else
    echo "   ⚠️  Ready check: $response"
fi

# Kill port-forward
kill $PF_PID 2>/dev/null || true

echo ""
echo "4. Checking backend logs..."
kubectl logs -n aroti -l app=backend --tail=10 | head -5

echo ""
echo "✅ Testing complete!"
echo ""
echo "To access services:"
echo "  kubectl port-forward -n aroti svc/backend 8888:8888"
echo "  curl http://localhost:8888/health"
echo ""
echo "To view logs:"
echo "  kubectl logs -n aroti -l app=backend -f"
