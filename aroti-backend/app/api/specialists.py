"""
Specialists API endpoints.
"""
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import get_current_user_id
from app.models.specialist import Specialist
from app.models.review import Review
from app.schemas.booking import SpecialistSchema, ReviewSchema
from app.cache.redis_client import redis_client
from app.config import settings

router = APIRouter()


@router.get("/specialists", response_model=List[SpecialistSchema])
async def get_specialists(
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id),
    availability: Optional[str] = Query(None),
    price_min: Optional[int] = Query(None),
    price_max: Optional[int] = Query(None),
    rating: Optional[str] = Query(None),
    languages: Optional[str] = Query(None),
    category: Optional[str] = Query(None)
):
    """
    Get list of specialists with optional filtering.
    Matches iOS BookingEndpoint.getSpecialists
    """
    # Check cache
    cache_key = f"specialists:list:{availability}:{price_min}:{price_max}:{rating}:{languages}:{category}"
    cached = await redis_client.get_json(cache_key)
    if cached:
        return cached
    
    # Query database
    query = db.query(Specialist)
    
    # Apply filters
    if availability == "available":
        query = query.filter(Specialist.available == True)
    elif availability == "unavailable":
        query = query.filter(Specialist.available == False)
    
    if price_min is not None:
        query = query.filter(Specialist.price >= price_min)
    
    if price_max is not None:
        query = query.filter(Specialist.price <= price_max)
    
    if rating:
        min_rating = float(rating)
        query = query.filter(Specialist.rating >= min_rating)
    
    if languages:
        lang_list = languages.split(",")
        query = query.filter(Specialist.languages.overlap(lang_list))
    
    if category:
        query = query.filter(Specialist.categories.contains([category]))
    
    specialists = query.all()
    
    # Convert to schemas
    result = [SpecialistSchema.model_validate(s) for s in specialists]
    
    # Cache result
    await redis_client.set_json(
        cache_key,
        [r.model_dump(by_alias=True) for r in result],
        ttl=settings.cache_ttl_specialists
    )
    
    return result


@router.get("/specialists/{specialist_id}", response_model=SpecialistSchema)
async def get_specialist(
    specialist_id: str,
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Get specialist by ID.
    Matches iOS BookingEndpoint.getSpecialist(id)
    """
    # Check cache
    cache_key = f"specialist:{specialist_id}"
    cached = await redis_client.get_json(cache_key)
    if cached:
        return cached
    
    # Query database
    specialist = db.query(Specialist).filter(Specialist.id == specialist_id).first()
    
    if not specialist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Specialist not found"
        )
    
    result = SpecialistSchema.model_validate(specialist)
    
    # Cache result
    await redis_client.set_json(
        cache_key,
        result.model_dump(by_alias=True),
        ttl=settings.cache_ttl_specialist_detail
    )
    
    return result


@router.get("/reviews/{specialist_id}", response_model=List[ReviewSchema])
async def get_reviews(
    specialist_id: str,
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Get reviews for a specialist.
    Matches iOS BookingEndpoint.getReviews(specialistId)
    """
    # Check cache
    cache_key = f"reviews:{specialist_id}"
    cached = await redis_client.get_json(cache_key)
    if cached:
        return cached
    
    # Query database
    reviews = db.query(Review).filter(Review.specialist_id == specialist_id).all()
    
    result = [ReviewSchema.model_validate(r) for r in reviews]
    
    # Cache result (shorter TTL for reviews)
    await redis_client.set_json(
        cache_key,
        [r.model_dump(by_alias=True) for r in result],
        ttl=600  # 10 minutes
    )
    
    return result
