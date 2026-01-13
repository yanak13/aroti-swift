"""
Review model matching iOS BookingModels.Review
"""
from sqlalchemy import Column, String, Integer, ForeignKey, Text
from sqlalchemy.orm import relationship

from app.database import Base


class Review(Base):
    __tablename__ = "reviews"
    
    id = Column(String, primary_key=True, index=True)
    specialist_id = Column(String, ForeignKey("specialists.id"), nullable=False, index=True)
    user_name = Column(String, nullable=False)
    rating = Column(Integer, nullable=False)  # 1-5
    comment = Column(Text)
    date = Column(String, nullable=False)  # ISO date string
    
    # Relationships
    specialist = relationship("Specialist", back_populates="reviews")
