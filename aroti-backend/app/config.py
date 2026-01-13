"""
Application configuration loaded from environment variables.
Matches kubernetes/aroti-backend/configmap.yaml settings.
"""
import os
from typing import Optional
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings from environment variables."""
    
    # Database
    database_url: str = os.getenv(
        "DATABASE_URL",
        "postgresql://postgres:postgres@localhost:5432/aroti"
    )
    
    # Redis
    redis_host: str = os.getenv("REDIS_HOST", "localhost")
    redis_port: int = int(os.getenv("REDIS_PORT", "6379"))
    redis_db: int = int(os.getenv("REDIS_DB", "0"))
    redis_password: Optional[str] = os.getenv("REDIS_PASSWORD")
    
    # Keycloak
    keycloak_issuer_uri: str = os.getenv(
        "KEYCLOAK_ISSUER_URI",
        "http://localhost:8080/realms/aroti"
    )
    keycloak_jwks_uri: Optional[str] = os.getenv("KEYCLOAK_JWKS_URI")
    keycloak_audience: str = os.getenv("KEYCLOAK_AUDIENCE", "aroti-app")
    
    # API
    api_port: int = int(os.getenv("API_PORT", "8888"))
    api_host: str = os.getenv("API_HOST", "0.0.0.0")
    api_debug: bool = os.getenv("API_DEBUG", "false").lower() == "true"
    
    # CORS
    cors_origins: list[str] = os.getenv(
        "CORS_ORIGINS",
        "http://localhost:3000,com.aroti.app://"
    ).split(",")
    
    # Temporal
    temporal_host: str = os.getenv(
        "TEMPORAL_HOST",
        "temporal-frontend.temporal.svc.cluster.local"
    )
    temporal_port: int = int(os.getenv("TEMPORAL_PORT", "7233"))
    temporal_namespace: str = os.getenv("TEMPORAL_NAMESPACE", "default")
    
    # Cache TTLs (in seconds)
    cache_ttl_specialists: int = int(os.getenv("CACHE_TTL_SPECIALISTS", "1800"))  # 30 min
    cache_ttl_specialist_detail: int = int(os.getenv("CACHE_TTL_SPECIALIST_DETAIL", "3600"))  # 1 hour
    
    class Config:
        env_file = ".env"
        case_sensitive = False


settings = Settings()
