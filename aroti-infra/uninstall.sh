#!/bin/bash
# Remove Aroti from k3s

set -e

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "🗑️  Uninstalling Aroti from k3s"
echo "================================"
echo ""

# Delete all resources
echo "Deleting all Aroti resources..."
kubectl delete -k . --ignore-not-found=true

echo ""
echo "Waiting for resources to be deleted..."
sleep 5

# Delete namespace (this will delete everything in it)
kubectl delete namespace aroti --ignore-not-found=true

echo ""
echo "✅ Aroti uninstalled successfully!"
echo ""
echo "To redeploy:"
echo "  ./deploy.sh"
