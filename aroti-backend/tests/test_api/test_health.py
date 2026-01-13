"""
Health check endpoint tests.
"""
import pytest
from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_check():
    """Test health check endpoint."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}


def test_readiness_check():
    """Test readiness check endpoint."""
    response = client.get("/ready")
    # May return 200 or 503 depending on database/Redis availability
    assert response.status_code in [200, 503]
    assert "status" in response.json()
    assert "checks" in response.json()
