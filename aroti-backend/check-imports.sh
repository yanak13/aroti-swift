#!/bin/bash
# Check all Python imports are valid

set -e

echo "🔍 Checking Python imports..."
echo ""

# Activate virtual environment
source venv/bin/activate

# Test all modules
modules=(
    "app.config"
    "app.database"
    "app.models.specialist"
    "app.models.session"
    "app.models.user"
    "app.models.review"
    "app.models.profile"
    "app.schemas.booking"
    "app.schemas.profile"
    "app.schemas.home"
    "app.auth.keycloak"
    "app.cache.redis_client"
    "app.api.health"
    "app.api.specialists"
    "app.api.sessions"
    "app.api.profile"
    "app.api.daily_insights"
    "app.workflows.session_booking"
    "app.workflows.activities"
)

failed=0

for module in "${modules[@]}"; do
    if python3 -c "import $module" 2>&1; then
        echo "✓ $module"
    else
        echo "❌ $module"
        failed=$((failed+1))
    fi
done

echo ""
if [ $failed -eq 0 ]; then
    echo "✅ All imports successful!"
    exit 0
else
    echo "❌ $failed imports failed"
    exit 1
fi
