"""
Health check endpoints.
"""
from fastapi import APIRouter, Depends
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.database import get_db
from app.cache.redis_client import redis_client

router = APIRouter()


@router.get("/health")
async def health_check():
    """Simple health check endpoint."""
    return {"status": "healthy"}


@router.get("/ready")
async def readiness_check(db: Session = Depends(get_db)):
    """
    Readiness check - verifies database and Redis connections.
    Used by Kubernetes liveness/readiness probes.
    """
    checks = {
        "database": False,
        "redis": False
    }
    
    # Check database
    try:
        db.execute(text("SELECT 1"))
        checks["database"] = True
    except Exception:
        pass
    
    # Check Redis
    try:
        checks["redis"] = await redis_client.ping()
    except Exception:
        pass
    
    if all(checks.values()):
        return {"status": "ready", "checks": checks}
    else:
        from fastapi import status
        from fastapi.responses import JSONResponse
        return JSONResponse(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            content={"status": "not ready", "checks": checks}
        )
