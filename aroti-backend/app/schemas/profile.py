"""
Pydantic schemas for profile endpoints matching iOS HomeModels.UserData
"""
from typing import Optional
from datetime import date, datetime
from pydantic import BaseModel, Field


class UserDataSchema(BaseModel):
    """Matches iOS HomeModels.UserData"""
    name: str
    sunSign: Optional[str] = Field(None, alias="sun_sign")
    moonSign: Optional[str] = Field(None, alias="moon_sign")
    birthDate: Optional[date] = Field(None, alias="birth_date")
    birthTime: Optional[datetime] = Field(None, alias="birth_time")
    birthLocation: Optional[str] = Field(None, alias="birth_location")
    traits: Optional[list[str]] = []
    isPremium: Optional[bool] = Field(False, alias="is_premium")
    
    class Config:
        populate_by_name = True
        from_attributes = True


class UpdateProfileRequest(BaseModel):
    """Request schema for updating user profile"""
    name: Optional[str] = None
    location: Optional[str] = None  # Maps to birth_location
    
    class Config:
        populate_by_name = True
