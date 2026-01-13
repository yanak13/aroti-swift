"""
Daily insights API endpoints.
"""
from fastapi import APIRouter, Depends
from datetime import date
from app.dependencies import get_current_user_id
from app.schemas.home import DailyInsightSchema, TarotCardSchema, RitualSchema, NumerologyInsightSchema
from app.cache.redis_client import redis_client

router = APIRouter()


@router.get("/daily-insights", response_model=DailyInsightSchema)
async def get_daily_insights(
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Get daily insights (tarot card, horoscope, numerology, ritual, affirmation).
    Matches iOS HomeEndpoint.getDailyInsights
    """
    today = date.today()
    
    # Check cache
    cache_key = f"daily_insights:{today.isoformat()}"
    cached = await redis_client.get_json(cache_key)
    if cached:
        return cached
    
    # Generate daily insights (simplified - in production this would use actual logic)
    # For now, return mock data matching iOS structure
    insight = DailyInsightSchema(
        tarotCard=TarotCardSchema(
            id="1",
            name="The Fool",
            keywords=["new beginnings", "adventure", "innocence"],
            interpretation="A new journey awaits you",
            guidance=["Trust your instincts", "Embrace the unknown"],
            imageName="tarot-fool"
        ),
        horoscope="Today brings opportunities for growth and reflection. Trust your intuition and be open to new experiences.",
        numerology=NumerologyInsightSchema(
            number=7,
            preview="A day of introspection and spiritual growth"
        ),
        ritual=RitualSchema(
            id="1",
            title="Morning Meditation",
            description="Start your day with a 10-minute meditation",
            duration="10 minutes",
            type="meditation",
            intention="Set positive intentions for the day",
            steps=["Find a quiet space", "Sit comfortably", "Focus on your breath"],
            affirmation="I am open to the wisdom of the universe",
            benefits=["Clarity", "Peace", "Focus"]
        ),
        affirmation="I trust the journey and embrace each moment with gratitude",
        date=today
    )
    
    # Cache for the day
    await redis_client.set_json(
        cache_key,
        insight.model_dump(by_alias=True),
        ttl=86400  # 24 hours
    )
    
    return insight
