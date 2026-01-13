"""
Sessions API endpoints.
"""
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
import uuid
from datetime import datetime

from app.database import get_db
from app.dependencies import get_current_user_id
from app.models.session import Session as SessionModel
from app.models.specialist import Specialist
from app.schemas.booking import SessionSchema, BookSessionRequest, UpdateSessionRequest
from app.cache.redis_client import redis_client

router = APIRouter()


@router.get("/sessions", response_model=List[SessionSchema])
async def get_sessions(
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id),
    status_filter: Optional[str] = None
):
    """
    Get user's sessions.
    Matches iOS BookingEndpoint.getSessions
    """
    query = db.query(SessionModel).filter(SessionModel.user_id == current_user_id)
    
    if status_filter:
        query = query.filter(SessionModel.status == status_filter)
    
    sessions = query.order_by(SessionModel.date, SessionModel.time).all()
    
    return [SessionSchema.model_validate(s) for s in sessions]


@router.get("/sessions/{session_id}", response_model=SessionSchema)
async def get_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Get session by ID.
    Matches iOS BookingEndpoint.getSession(id)
    """
    session = db.query(SessionModel).filter(
        SessionModel.id == session_id,
        SessionModel.user_id == current_user_id
    ).first()
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found"
        )
    
    return SessionSchema.model_validate(session)


@router.post("/sessions", response_model=SessionSchema, status_code=status.HTTP_201_CREATED)
async def book_session(
    request: BookSessionRequest,
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Book a new session.
    Matches iOS BookingEndpoint.bookSession
    """
    # Get specialist
    specialist = db.query(Specialist).filter(Specialist.id == request.specialistId).first()
    
    if not specialist:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Specialist not found"
        )
    
    if not specialist.available:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Specialist is not available"
        )
    
    # Create session
    session_id = str(uuid.uuid4())
    new_session = SessionModel(
        id=session_id,
        specialist_id=request.specialistId,
        user_id=current_user_id,
        specialist_name=specialist.name,
        specialist_photo=specialist.photo,
        specialty=specialist.specialty,
        date=request.date,
        time=request.time,
        duration=50,  # Default duration
        price=specialist.price,
        status="pending"
    )
    
    db.add(new_session)
    db.commit()
    db.refresh(new_session)
    
    # Invalidate cache
    await redis_client.delete(f"sessions:user:{current_user_id}")
    
    # TODO: Trigger Temporal workflow for session booking
    # from app.workflows.session_booking import start_booking_workflow
    # await start_booking_workflow(new_session.id)
    
    return SessionSchema.model_validate(new_session)


@router.put("/sessions/{session_id}", response_model=SessionSchema)
async def update_session(
    session_id: str,
    request: UpdateSessionRequest,
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Update a session.
    Matches iOS BookingEndpoint.updateSession
    """
    session = db.query(SessionModel).filter(
        SessionModel.id == session_id,
        SessionModel.user_id == current_user_id
    ).first()
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found"
        )
    
    # Update fields
    if request.date:
        session.date = request.date
    if request.time:
        session.time = request.time
    
    session.updated_at = datetime.utcnow()
    
    db.commit()
    db.refresh(session)
    
    # Invalidate cache
    await redis_client.delete(f"sessions:user:{current_user_id}")
    
    return SessionSchema.model_validate(session)


@router.delete("/sessions/{session_id}", status_code=status.HTTP_204_NO_CONTENT)
async def cancel_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user_id: str = Depends(get_current_user_id)
):
    """
    Cancel a session.
    Matches iOS BookingEndpoint.cancelSession
    """
    session = db.query(SessionModel).filter(
        SessionModel.id == session_id,
        SessionModel.user_id == current_user_id
    ).first()
    
    if not session:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Session not found"
        )
    
    # Update status to cancelled instead of deleting
    session.status = "cancelled"
    session.updated_at = datetime.utcnow()
    
    db.commit()
    
    # Invalidate cache
    await redis_client.delete(f"sessions:user:{current_user_id}")
    
    return None
