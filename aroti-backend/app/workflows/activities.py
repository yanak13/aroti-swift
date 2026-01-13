"""
Temporal activities for session booking workflow.
"""
from temporalio import activity
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models.session import Session as SessionModel
from app.models.specialist import Specialist
import logging
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from app.workflows.session_booking import BookingRequest

logger = logging.getLogger(__name__)


@activity.defn
async def check_specialist_availability(
    specialist_id: str,
    date: str,
    time: str
) -> bool:
    """
    Check if specialist is available at the requested date/time.
    """
    db: Session = SessionLocal()
    try:
        specialist = db.query(Specialist).filter(Specialist.id == specialist_id).first()
        if not specialist or not specialist.available:
            return False
        
        # Check for existing sessions at the same time
        existing = db.query(SessionModel).filter(
            SessionModel.specialist_id == specialist_id,
            SessionModel.date == date,
            SessionModel.time == time,
            SessionModel.status.in_(["pending", "upcoming"])
        ).first()
        
        return existing is None
    finally:
        db.close()


@activity.defn
async def create_session_record(booking_request: dict) -> dict:
    """
    Create session record in database.
    """
    db: Session = SessionLocal()
    try:
        specialist = db.query(Specialist).filter(
            Specialist.id == booking_request["specialist_id"]
        ).first()
        
        if not specialist:
            raise ValueError(f"Specialist {booking_request['specialist_id']} not found")
        
        session = SessionModel(
            id=booking_request["session_id"],
            specialist_id=booking_request["specialist_id"],
            user_id=booking_request["user_id"],
            specialist_name=specialist.name,
            specialist_photo=specialist.photo,
            specialty=specialist.specialty,
            date=booking_request["date"],
            time=booking_request["time"],
            duration=50,
            price=specialist.price,
            status="pending"
        )
        
        db.add(session)
        db.commit()
        db.refresh(session)
        
        return {
            "session_id": session.id,
            "specialist_name": session.specialist_name,
            "date": session.date,
            "time": session.time
        }
    finally:
        db.close()


@activity.defn
async def send_confirmation_email(user_id: str, session_data: dict) -> None:
    """
    Send confirmation email to user.
    TODO: Integrate with email service (SendGrid, SES, etc.)
    """
    logger.info(f"Sending confirmation email to user {user_id} for session {session_data.get('session_id')}")
    # Placeholder for email sending logic
    pass


@activity.defn
async def schedule_reminder(
    user_id: str,
    date: str,
    time: str
) -> None:
    """
    Schedule a reminder notification 24 hours before the session.
    TODO: Integrate with notification service
    """
    logger.info(f"Scheduling reminder for user {user_id} for session on {date} at {time}")
    # Placeholder for reminder scheduling logic
    pass


@activity.defn
async def generate_meeting_link(session_id: str) -> str:
    """
    Generate meeting link for the session.
    TODO: Integrate with video conferencing service (Zoom, Google Meet, etc.)
    """
    # Placeholder - generate a meeting link
    meeting_link = f"https://meet.aroti.app/session-{session_id}"
    logger.info(f"Generated meeting link for session {session_id}: {meeting_link}")
    return meeting_link
