"""
Specialist model matching iOS BookingModels.Specialist
"""
from sqlalchemy import Column, String, Float, Integer, Boolean, Text, ARRAY
from sqlalchemy.orm import relationship

from app.database import Base


class Specialist(Base):
    __tablename__ = "specialists"
    
    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False)
    specialty = Column(String, nullable=False)
    categories = Column(ARRAY(String), default=[])
    country = Column(String)
    country_flag = Column(String)  # Emoji flag
    rating = Column(Float, default=0.0)
    review_count = Column(Integer, default=0)
    session_count = Column(Integer, default=0)
    price = Column(Integer, nullable=False)  # Price in cents or base currency
    bio = Column(Text)
    years_of_practice = Column(Integer, default=0)
    photo = Column(String)  # URL or asset name
    available = Column(Boolean, default=True)
    languages = Column(ARRAY(String), default=[])
    added_date = Column(String)  # ISO date string
    
    # Relationships
    reviews = relationship("Review", back_populates="specialist", cascade="all, delete-orphan")
    sessions = relationship("Session", back_populates="specialist", cascade="all, delete-orphan")
