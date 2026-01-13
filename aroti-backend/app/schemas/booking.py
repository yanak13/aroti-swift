"""
Pydantic schemas for booking endpoints matching iOS BookingModels
"""
from typing import Optional
from pydantic import BaseModel, Field


class SpecialistSchema(BaseModel):
    """Matches iOS BookingModels.Specialist"""
    id: str
    name: str
    specialty: str
    categories: list[str] = []
    country: str
    countryFlag: str = Field(alias="country_flag")
    rating: float
    reviewCount: int = Field(alias="review_count")
    sessionCount: int = Field(alias="session_count")
    price: int
    bio: str
    yearsOfPractice: int = Field(alias="years_of_practice")
    photo: str
    available: bool
    languages: list[str] = []
    addedDate: Optional[str] = Field(None, alias="added_date")
    
    class Config:
        populate_by_name = True
        from_attributes = True


class ReviewSchema(BaseModel):
    """Matches iOS BookingModels.Review"""
    id: str
    specialistId: str = Field(alias="specialist_id")
    userName: str = Field(alias="user_name")
    rating: int
    comment: str
    date: str
    
    class Config:
        populate_by_name = True
        from_attributes = True


class SessionSchema(BaseModel):
    """Matches iOS BookingModels.Session"""
    id: str
    specialistId: str = Field(alias="specialist_id")
    specialistName: str = Field(alias="specialist_name")
    specialistPhoto: str = Field(alias="specialist_photo")
    specialty: str
    date: str
    time: str
    duration: int
    price: int
    status: str
    meetingLink: Optional[str] = Field(None, alias="meeting_link")
    preparationNotes: Optional[str] = Field(None, alias="preparation_notes")
    
    class Config:
        populate_by_name = True
        from_attributes = True


class BookSessionRequest(BaseModel):
    """Request schema for booking a session"""
    specialistId: str = Field(alias="specialist_id")
    date: str  # YYYY-MM-DD
    time: str  # HH:MM
    
    class Config:
        populate_by_name = True


class UpdateSessionRequest(BaseModel):
    """Request schema for updating a session"""
    date: Optional[str] = None  # YYYY-MM-DD
    time: Optional[str] = None  # HH:MM
    
    class Config:
        populate_by_name = True
