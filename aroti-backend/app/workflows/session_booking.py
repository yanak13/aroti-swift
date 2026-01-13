"""
Temporal workflow for session booking process.
"""
from dataclasses import dataclass
from temporalio import workflow
from temporalio.common import RetryPolicy

from app.workflows.activities import (
    check_specialist_availability,
    create_session_record,
    send_confirmation_email,
    schedule_reminder,
    generate_meeting_link
)


@dataclass
class BookingRequest:
    """Request data for booking workflow."""
    session_id: str
    specialist_id: str
    user_id: str
    date: str
    time: str


@workflow.defn
class SessionBookingWorkflow:
    """Workflow for booking a session with a specialist."""
    
    @workflow.run
    async def run(self, booking_request: BookingRequest) -> dict:
        """
        Main workflow execution.
        
        Steps:
        1. Check specialist availability
        2. Create session record
        3. Send confirmation email
        4. Schedule reminder (24h before)
        5. Generate meeting link
        """
        retry_policy = RetryPolicy(
            initial_interval=1.0,
            backoff_coefficient=2.0,
            maximum_interval=60.0,
            maximum_attempts=3
        )
        
        # Step 1: Check availability
        is_available = await workflow.execute_activity(
            check_specialist_availability,
            booking_request.specialist_id,
            booking_request.date,
            booking_request.time,
            start_to_close_timeout=30.0,
            retry_policy=retry_policy
        )
        
        if not is_available:
            return {
                "success": False,
                "error": "Specialist is not available at the requested time"
            }
        
        # Step 2: Create session record
        session_data = await workflow.execute_activity(
            create_session_record,
            {
                "session_id": booking_request.session_id,
                "specialist_id": booking_request.specialist_id,
                "user_id": booking_request.user_id,
                "date": booking_request.date,
                "time": booking_request.time
            },
            start_to_close_timeout=30.0,
            retry_policy=retry_policy
        )
        
        # Step 3: Send confirmation email (fire and forget)
        workflow.execute_activity(
            send_confirmation_email,
            booking_request.user_id,
            session_data,
            start_to_close_timeout=60.0,
            retry_policy=retry_policy
        )
        
        # Step 4: Schedule reminder (24 hours before session)
        workflow.execute_activity(
            schedule_reminder,
            booking_request.user_id,
            booking_request.date,
            booking_request.time,
            start_to_close_timeout=30.0,
            retry_policy=retry_policy
        )
        
        # Step 5: Generate meeting link
        meeting_link = await workflow.execute_activity(
            generate_meeting_link,
            booking_request.session_id,
            start_to_close_timeout=30.0,
            retry_policy=retry_policy
        )
        
        return {
            "success": True,
            "session_id": booking_request.session_id,
            "meeting_link": meeting_link
        }
