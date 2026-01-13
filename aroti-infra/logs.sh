#!/bin/bash
# View logs from different services

set -e

export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

SERVICE=${1:-backend}

echo "📋 Viewing logs for: $SERVICE"
echo "=============================="
echo ""

case $SERVICE in
  backend)
    kubectl logs -n aroti -l app=backend -f --max-log-requests=10
    ;;
  worker)
    kubectl logs -n aroti -l app=backend-worker -f
    ;;
  postgres)
    kubectl logs -n aroti -l app=postgres -f
    ;;
  redis)
    kubectl logs -n aroti -l app=redis -f
    ;;
  keycloak)
    kubectl logs -n aroti -l app=keycloak -f
    ;;
  all)
    kubectl logs -n aroti --all-containers=true -f --max-log-requests=20
    ;;
  *)
    echo "Usage: ./logs.sh [backend|worker|postgres|redis|keycloak|all]"
    echo ""
    echo "Available services:"
    kubectl get pods -n aroti -o wide
    exit 1
    ;;
esac
