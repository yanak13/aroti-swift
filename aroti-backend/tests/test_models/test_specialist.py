"""
Specialist model tests.
"""
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.database import Base
from app.models.specialist import Specialist


@pytest.fixture
def db_session():
    """Create in-memory database session for testing."""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    Session = sessionmaker(bind=engine)
    session = Session()
    yield session
    session.close()


def test_create_specialist(db_session):
    """Test creating a specialist."""
    specialist = Specialist(
        id="test-1",
        name="Test Specialist",
        specialty="Test Specialty",
        categories=["Category1", "Category2"],
        country="USA",
        country_flag="🇺🇸",
        rating=4.5,
        review_count=10,
        session_count=20,
        price=50,
        bio="Test bio",
        years_of_practice=5,
        photo="test-photo",
        available=True,
        languages=["English"]
    )
    
    db_session.add(specialist)
    db_session.commit()
    
    retrieved = db_session.query(Specialist).filter(Specialist.id == "test-1").first()
    assert retrieved is not None
    assert retrieved.name == "Test Specialist"
    assert retrieved.rating == 4.5
