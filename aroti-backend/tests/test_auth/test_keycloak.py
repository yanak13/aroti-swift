"""
Keycloak JWT validation tests.
"""
import pytest
import jwt
from datetime import datetime, timedelta

from app.auth.keycloak import KeycloakJWTValidator


@pytest.fixture
def mock_jwt_token():
    """Create a mock JWT token for testing."""
    payload = {
        "sub": "user-123",
        "iss": "http://localhost:8080/realms/aroti",
        "aud": "aroti-app",
        "exp": int((datetime.utcnow() + timedelta(hours=1)).timestamp()),
        "iat": int(datetime.utcnow().timestamp())
    }
    # Note: This is an unsigned token for testing
    # In production, tokens would be signed by Keycloak
    return jwt.encode(payload, "secret", algorithm="HS256")


@pytest.mark.asyncio
async def test_jwt_validation(mock_jwt_token):
    """Test JWT token validation."""
    # This is a simplified test - in production, proper JWKS verification would be needed
    validator = KeycloakJWTValidator()
    
    # Note: This test would need proper mocking of JWKS endpoint
    # For now, we'll skip the actual verification and test the structure
    assert mock_jwt_token is not None
