"""
Pydantic schemas for home/daily insights endpoints matching iOS HomeModels
"""
from typing import Optional
from datetime import date
from pydantic import BaseModel


class TarotCardSchema(BaseModel):
    """Matches iOS HomeModels.TarotCard"""
    id: str
    name: str
    keywords: list[str]
    interpretation: Optional[str] = None
    guidance: Optional[list[str]] = None
    imageName: Optional[str] = None


class RitualSchema(BaseModel):
    """Matches iOS HomeModels.Ritual"""
    id: str
    title: str
    description: str
    duration: str
    type: str
    intention: Optional[str] = None
    steps: Optional[list[str]] = None
    affirmation: Optional[str] = None
    benefits: Optional[list[str]] = None


class NumerologyInsightSchema(BaseModel):
    """Matches iOS HomeModels.NumerologyInsight"""
    number: int
    preview: str


class DailyInsightSchema(BaseModel):
    """Matches iOS HomeModels.DailyInsight"""
    tarotCard: Optional[TarotCardSchema] = None
    horoscope: str
    numerology: NumerologyInsightSchema
    ritual: RitualSchema
    affirmation: str
    date: date
