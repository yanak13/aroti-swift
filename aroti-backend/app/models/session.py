"""
Session model matching iOS BookingModels.Session
"""
from sqlalchemy import Column, String, Integer, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from datetime import datetime

from app.database import Base


class Session(Base):
    __tablename__ = "sessions"
    
    id = Column(String, primary_key=True, index=True)
    specialist_id = Column(String, ForeignKey("specialists.id"), nullable=False)
    user_id = Column(String, nullable=False, index=True)  # From JWT sub claim
    specialist_name = Column(String, nullable=False)
    specialist_photo = Column(String)
    specialty = Column(String)
    date = Column(String, nullable=False)  # ISO date string (YYYY-MM-DD)
    time = Column(String, nullable=False)  # Time string (HH:MM)
    duration = Column(Integer, default=50)  # Duration in minutes
    price = Column(Integer, nullable=False)
    status = Column(String, default="pending")  # "upcoming", "completed", "pending", "cancelled"
    meeting_link = Column(String)
    preparation_notes = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationships
    specialist = relationship("Specialist", back_populates="sessions")
