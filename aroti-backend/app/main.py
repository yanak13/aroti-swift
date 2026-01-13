"""
FastAPI application entry point.
"""
import logging
import time
from contextlib import asynccontextmanager
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from sqlalchemy import text

from app.config import settings
from app.database import engine, Base
from app.cache.redis_client import redis_client
from app.api import specialists, sessions, profile, daily_insights, health

# Configure logging
logging.basicConfig(
    level=logging.DEBUG if settings.api_debug else logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Application lifespan events.
    - On startup: Initialize database, Redis connection
    - On shutdown: Close connections
    """
    # Startup
    logger.info("Starting Aroti Backend API...")
    
    # Test database connection
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        logger.info("Database connection successful")
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        raise
    
    # Test Redis connection
    try:
        await redis_client.ping()
        logger.info("Redis connection successful")
    except Exception as e:
        logger.warning(f"Redis connection failed: {e}")
    
    yield
    
    # Shutdown
    logger.info("Shutting down Aroti Backend API...")
    await redis_client.close()


# Create FastAPI app
app = FastAPI(
    title="Aroti Backend API",
    description="Backend API for Aroti iOS application",
    version="1.0.0",
    lifespan=lifespan
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Request ID middleware for logging
@app.middleware("http")
async def add_request_id(request: Request, call_next):
    """Add request ID to each request for tracing."""
    import uuid
    request_id = str(uuid.uuid4())[:8]
    request.state.request_id = request_id
    
    start_time = time.time()
    
    # Process request
    response = await call_next(request)
    
    # Log request
    process_time = time.time() - start_time
    logger.info(
        f"[{request_id}] {request.method} {request.url.path} - "
        f"{response.status_code} - {process_time:.3f}s"
    )
    
    # Add request ID to response header
    response.headers["X-Request-ID"] = request_id
    
    return response


# Exception handlers
@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Global exception handler."""
    logger.error(f"Unhandled exception: {exc}", exc_info=True)
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "detail": "Internal server error",
            "request_id": getattr(request.state, "request_id", None)
        }
    )


# Register API routers
app.include_router(health.router, tags=["Health"])
app.include_router(specialists.router, prefix="/api", tags=["Specialists"])
app.include_router(sessions.router, prefix="/api", tags=["Sessions"])
app.include_router(profile.router, prefix="/api", tags=["Profile"])
app.include_router(daily_insights.router, prefix="/api", tags=["Daily Insights"])


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host=settings.api_host,
        port=settings.api_port,
        reload=settings.api_debug
    )
