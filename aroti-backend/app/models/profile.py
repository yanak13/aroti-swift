"""
Profile model - additional user profile information
This can be extended with more fields as needed.
"""
from sqlalchemy import Column, String, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from datetime import datetime

from app.database import Base


class UserProfile(Base):
    __tablename__ = "user_profiles"
    
    id = Column(String, primary_key=True, index=True)
    user_id = Column(String, ForeignKey("users.id"), nullable=False, unique=True, index=True)
    avatar_url = Column(String)
    bio = Column(Text)
    preferences = Column(Text)  # JSON string for user preferences
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    user = relationship("User", backref="profile")
