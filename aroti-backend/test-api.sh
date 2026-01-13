#!/bin/bash
# Test API endpoints

set -e

BASE_URL="http://localhost:8888"

echo "🧪 Testing Aroti Backend API"
echo "=============================="
echo ""

# Test health endpoint
echo "1. Testing health endpoint..."
response=$(curl -s -w "\n%{http_code}" $BASE_URL/health)
status_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | head -n -1)

if [ "$status_code" = "200" ]; then
    echo "   ✓ Health check passed"
    echo "   Response: $body"
else
    echo "   ❌ Health check failed (status: $status_code)"
fi
echo ""

# Test ready endpoint
echo "2. Testing readiness endpoint..."
response=$(curl -s -w "\n%{http_code}" $BASE_URL/ready)
status_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | head -n -1)

if [ "$status_code" = "200" ]; then
    echo "   ✓ Readiness check passed"
    echo "   Response: $body"
else
    echo "   ⚠️  Readiness check returned status: $status_code"
    echo "   Response: $body"
fi
echo ""

# Test specialists endpoint (requires auth, will return 401 or 403)
echo "3. Testing specialists endpoint (without auth)..."
response=$(curl -s -w "\n%{http_code}" $BASE_URL/api/specialists)
status_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | head -n -1)

if [ "$status_code" = "401" ] || [ "$status_code" = "403" ]; then
    echo "   ✓ Correctly requires authentication (status: $status_code)"
else
    echo "   Status: $status_code"
    echo "   Response: $body"
fi
echo ""

echo "✅ Basic API tests complete!"
echo ""
echo "For authenticated requests, you need a JWT token from Keycloak."
echo "See README.md for Keycloak configuration."
