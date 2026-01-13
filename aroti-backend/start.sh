#!/bin/bash
# Start the Aroti backend API server

set -e

echo "🚀 Starting Aroti Backend API..."

# Check if services are running
if ! docker ps | grep -q postgres; then
    echo "❌ PostgreSQL is not running. Run ./setup.sh first."
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Set environment variables
export DATABASE_URL="postgresql://postgres:dev_password@localhost:5432/aroti_dev"
export REDIS_HOST="localhost"
export REDIS_PORT="6379"
export KEYCLOAK_ISSUER_URI="http://localhost:8080/realms/aroti"
export API_PORT="8888"
export API_DEBUG="true"
export CORS_ORIGINS="http://localhost:3000,com.aroti.app://"

echo "✓ Starting API server on http://localhost:8888"
echo "✓ API docs available at http://localhost:8888/docs"
echo ""

# Start the server
uvicorn app.main:app --host 0.0.0.0 --port 8888 --reload
