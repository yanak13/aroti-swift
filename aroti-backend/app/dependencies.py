"""
FastAPI dependencies for authentication and common utilities.
"""
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import Optional

from app.database import get_db
from app.auth.keycloak import get_current_user


def get_current_user_id(
    current_user: dict = Depends(get_current_user)
) -> str:
    """
    Extract user ID from JWT token.
    Returns the 'sub' claim which contains the user ID.
    """
    user_id = current_user.get("sub")
    if not user_id:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid token: missing user ID"
        )
    return user_id


def get_db_session(
    db: Session = Depends(get_db)
) -> Session:
    """
    Dependency to get database session.
    """
    return db
