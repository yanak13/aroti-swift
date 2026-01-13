#!/bin/bash
# Setup script for Aroti backend development

set -e

echo "🚀 Aroti Backend Setup Script"
echo "=============================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
    exit 1
fi

# Check if Docker daemon is running
if ! docker ps &> /dev/null; then
    echo "❌ Docker daemon is not running."
    echo "   Please start Docker Desktop and try again."
    exit 1
fi

echo "✓ Docker is installed and running"

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.11+"
    exit 1
fi

echo "✓ Python $(python3 --version) found"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment and install dependencies
echo "📦 Installing Python dependencies..."
source venv/bin/activate
pip install --upgrade pip -q
pip install -r requirements.txt -q

echo "✓ Python dependencies installed"

# Start Docker services
echo "🐳 Starting Docker services (PostgreSQL, Redis, Keycloak)..."
docker-compose up -d postgres redis keycloak

echo "⏳ Waiting for services to be ready..."
sleep 10

# Wait for PostgreSQL
echo "   Waiting for PostgreSQL..."
until docker-compose exec -T postgres pg_isready -U postgres &> /dev/null; do
    echo -n "."
    sleep 1
done
echo " ✓"

# Wait for Redis
echo "   Waiting for Redis..."
until docker-compose exec -T redis redis-cli ping &> /dev/null; do
    echo -n "."
    sleep 1
done
echo " ✓"

# Run database migrations
echo "🗄️  Running database migrations..."
export DATABASE_URL="postgresql://postgres:dev_password@localhost:5432/aroti_dev"
alembic upgrade head

echo ""
echo "✅ Setup complete!"
echo ""
echo "Services running:"
echo "  - PostgreSQL: localhost:5432"
echo "  - Redis: localhost:6379"
echo "  - Keycloak: http://localhost:8080"
echo ""
echo "To start the API server, run:"
echo "  ./start.sh"
echo ""
echo "To stop services:"
echo "  docker-compose down"
