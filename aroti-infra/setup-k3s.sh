#!/bin/bash
# Setup k3s on local machine

set -e

echo "🚀 Setting up k3s for Aroti"
echo "=============================="
echo ""

# Check if k3s is already installed
if command -v k3s &> /dev/null; then
    echo "✓ k3s is already installed"
    k3s --version
else
    echo "📦 Installing k3s..."
    
    # Install k3s
    curl -sfL https://get.k3s.io | sh -
    
    echo "✓ k3s installed successfully"
fi

# Wait for k3s to be ready
echo ""
echo "⏳ Waiting for k3s to be ready..."
sleep 10

# Configure kubectl
echo ""
echo "🔧 Configuring kubectl..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Test kubectl
if kubectl get nodes &> /dev/null; then
    echo "✓ kubectl configured successfully"
    kubectl get nodes
else
    echo "❌ kubectl configuration failed"
    echo "Run: export KUBECONFIG=/etc/rancher/k3s/k3s.yaml"
    exit 1
fi

echo ""
echo "✅ k3s setup complete!"
echo ""
echo "Next steps:"
echo "  1. Build backend image: cd ../aroti-backend && ./build-k8s.sh"
echo "  2. Deploy to k3s: cd ../aroti-infra && ./deploy.sh"
