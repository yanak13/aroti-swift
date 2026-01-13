"""
Redis cache client for distributed caching.
"""
import json
import logging
from typing import Optional, Any
import redis.asyncio as redis
from redis.asyncio import Redis

from app.config import settings

logger = logging.getLogger(__name__)


class RedisClient:
    """Async Redis client wrapper."""
    
    def __init__(self):
        self._client: Optional[Redis] = None
    
    async def connect(self):
        """Connect to Redis."""
        if self._client is None:
            try:
                self._client = await redis.from_url(
                    f"redis://{settings.redis_host}:{settings.redis_port}/{settings.redis_db}",
                    password=settings.redis_password,
                    encoding="utf-8",
                    decode_responses=True
                )
                logger.info("Connected to Redis")
            except Exception as e:
                logger.error(f"Failed to connect to Redis: {e}")
                raise
    
    async def ping(self) -> bool:
        """Test Redis connection."""
        if self._client is None:
            await self.connect()
        try:
            await self._client.ping()
            return True
        except Exception as e:
            logger.error(f"Redis ping failed: {e}")
            return False
    
    async def get(self, key: str) -> Optional[str]:
        """Get value from cache."""
        if self._client is None:
            await self.connect()
        try:
            return await self._client.get(key)
        except Exception as e:
            logger.error(f"Redis get error: {e}")
            return None
    
    async def set(
        self,
        key: str,
        value: str,
        ttl: Optional[int] = None
    ) -> bool:
        """Set value in cache with optional TTL."""
        if self._client is None:
            await self.connect()
        try:
            if ttl:
                await self._client.setex(key, ttl, value)
            else:
                await self._client.set(key, value)
            return True
        except Exception as e:
            logger.error(f"Redis set error: {e}")
            return False
    
    async def delete(self, key: str) -> bool:
        """Delete key from cache."""
        if self._client is None:
            await self.connect()
        try:
            await self._client.delete(key)
            return True
        except Exception as e:
            logger.error(f"Redis delete error: {e}")
            return False
    
    async def get_json(self, key: str) -> Optional[Any]:
        """Get and deserialize JSON value."""
        value = await self.get(key)
        if value:
            try:
                return json.loads(value)
            except json.JSONDecodeError:
                return None
        return None
    
    async def set_json(
        self,
        key: str,
        value: Any,
        ttl: Optional[int] = None
    ) -> bool:
        """Serialize and set JSON value."""
        try:
            json_value = json.dumps(value)
            return await self.set(key, json_value, ttl)
        except (TypeError, ValueError) as e:
            logger.error(f"JSON serialization error: {e}")
            return False
    
    async def close(self):
        """Close Redis connection."""
        if self._client:
            await self._client.close()
            self._client = None


# Global Redis client instance
redis_client = RedisClient()
