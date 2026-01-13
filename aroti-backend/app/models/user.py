"""
User model for storing user profile data matching iOS HomeModels.UserData
"""
from sqlalchemy import Column, String, Boolean, ARRAY, Date, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime

from app.database import Base


class User(Base):
    __tablename__ = "users"
    
    id = Column(String, primary_key=True, index=True)  # Keycloak user ID (sub claim)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, index=True)
    sun_sign = Column(String)
    moon_sign = Column(String)
    birth_date = Column(Date)
    birth_time = Column(DateTime)  # Store as datetime for time component
    birth_location = Column(String)
    traits = Column(ARRAY(String), default=[])
    is_premium = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    sessions = relationship("Session", foreign_keys="Session.user_id", viewonly=True)
