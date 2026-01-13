# Alternative Setup with Homebrew (No Docker)

If you prefer to run services natively without Docker, use Homebrew:

## 1. Install Services

```bash
# Install PostgreSQL
brew install postgresql@15
brew services start postgresql@15

# Install Redis
brew install redis
brew services start redis

# Verify services are running
brew services list
```

## 2. Create Database

```bash
# Create database
createdb aroti_dev

# Verify connection
psql aroti_dev -c "SELECT version();"
```

## 3. Install Python Dependencies

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## 4. Run Migrations

```bash
export DATABASE_URL="postgresql://$(whoami)@localhost:5432/aroti_dev"
alembic upgrade head
```

## 5. Start API Server

```bash
# Set environment variables
export DATABASE_URL="postgresql://$(whoami)@localhost:5432/aroti_dev"
export REDIS_HOST="localhost"
export REDIS_PORT="6379"
export KEYCLOAK_ISSUER_URI="http://localhost:8080/realms/aroti"
export API_PORT="8888"
export API_DEBUG="true"

# Start server
uvicorn app.main:app --reload
```

## 6. Keycloak Setup (Optional)

For full OAuth testing, you'll need Keycloak. You can either:

### Option A: Run Keycloak with Docker

```bash
docker run -d \
  -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=admin \
  quay.io/keycloak/keycloak:26.0 \
  start-dev
```

### Option B: Download Keycloak

Download from: https://www.keycloak.org/downloads

```bash
# Extract and run
cd keycloak-26.0.0
bin/kc.sh start-dev
```

## Configure Keycloak

1. Open http://localhost:8080
2. Login with admin/admin
3. Create realm "aroti"
4. Create client "aroti-ios":
   - Client ID: `aroti-ios`
   - Client type: `Public`
   - Valid redirect URIs: `com.aroti.app://oauth/callback`
   - Web origins: `*`

## Testing Without Keycloak

You can test most endpoints by mocking the JWT token in development. Update `app/auth/keycloak.py` to add a development bypass (see README.md for details).

## Service Management

```bash
# Stop services
brew services stop postgresql@15
brew services stop redis

# Restart services
brew services restart postgresql@15
brew services restart redis

# Check service status
brew services list
```

## Cleanup

```bash
# Remove database
dropdb aroti_dev

# Uninstall services (optional)
brew uninstall postgresql@15 redis
```
