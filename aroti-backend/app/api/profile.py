"""
User profile API endpoints.
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import datetime

from app.database import get_db
from app.dependencies import get_current_user_id
from app.models.user import User
from app.schemas.profile import UserDataSchema, UpdateProfileRequest
from app.cache.redis_client import redis_client

router = APIRouter()


@router.get("/user/profile", response_model=UserDataSchema)
async def get_profile(
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Get user profile.
    Matches iOS ProfileEndpoint.getProfile
    """
    # Check cache
    cache_key = f"profile:{current_user_id}"
    cached = await redis_client.get_json(cache_key)
    if cached:
        return cached
    
    # Query or create user
    user = db.query(User).filter(User.id == current_user_id).first()
    
    if not user:
        # Create new user record
        user = User(
            id=current_user_id,
            name="User",  # Default name, can be updated
            email=""  # Can be extracted from token if available
        )
        db.add(user)
        db.commit()
        db.refresh(user)
    
    result = UserDataSchema.model_validate(user)
    
    # Cache result
    await redis_client.set_json(
        cache_key,
        result.model_dump(by_alias=True),
        ttl=300  # 5 minutes
    )
    
    return result


@router.put("/user/profile", response_model=UserDataSchema)
async def update_profile(
    request: UpdateProfileRequest,
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Update user profile.
    Matches iOS ProfileEndpoint.updateProfile
    """
    user = db.query(User).filter(User.id == current_user_id).first()
    
    if not user:
        # Create new user if doesn't exist
        user = User(
            id=current_user_id,
            name=request.name or "User",
            email=""
        )
        db.add(user)
    else:
        # Update existing user
        if request.name:
            user.name = request.name
        if request.location:
            user.birth_location = request.location
        
        user.updated_at = datetime.utcnow()
    
    db.commit()
    db.refresh(user)
    
    # Invalidate cache
    await redis_client.delete(f"profile:{current_user_id}")
    
    return UserDataSchema.model_validate(user)


@router.delete("/user/account", status_code=status.HTTP_204_NO_CONTENT)
async def delete_account(
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Delete user account.
    Matches iOS ProfileEndpoint.deleteAccount
    """
    user = db.query(User).filter(User.id == current_user_id).first()
    
    if user:
        db.delete(user)
        db.commit()
    
    # Invalidate cache
    await redis_client.delete(f"profile:{current_user_id}")
    
    return None
