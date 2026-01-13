"""
Temporal worker for executing workflows and activities.
"""
import asyncio
import logging
from temporalio.client import Client
from temporalio.worker import Worker

from app.config import settings
from app.workflows.session_booking import SessionBookingWorkflow
from app.workflows.activities import (
    check_specialist_availability,
    create_session_record,
    send_confirmation_email,
    schedule_reminder,
    generate_meeting_link
)

logger = logging.getLogger(__name__)


async def run_worker():
    """Run Temporal worker."""
    # Connect to Temporal server
    client = await Client.connect(
        f"{settings.temporal_host}:{settings.temporal_port}",
        namespace=settings.temporal_namespace
    )
    
    logger.info(f"Connected to Temporal at {settings.temporal_host}:{settings.temporal_port}")
    
    # Create worker
    worker = Worker(
        client,
        task_queue="session-booking",
        workflows=[SessionBookingWorkflow],
        activities=[
            check_specialist_availability,
            create_session_record,
            send_confirmation_email,
            schedule_reminder,
            generate_meeting_link
        ]
    )
    
    logger.info("Starting Temporal worker...")
    await worker.run()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    asyncio.run(run_worker())
