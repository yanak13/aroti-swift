"""Seed data

Revision ID: 002_seed
Revises: 001_initial
Create Date: 2024-01-01 00:01:00.000000

"""
from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision = '002_seed'
down_revision = '001_initial'
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Insert sample specialists matching iOS mock data
    op.execute("""
        INSERT INTO specialists (id, name, specialty, categories, country, country_flag, rating, review_count, session_count, price, bio, years_of_practice, photo, available, languages, added_date)
        VALUES
        ('1', 'Raluca', 'Astrologer', ARRAY['Astrology', 'Moon Cycles', 'Emotional Healing'], 'Romania', '🇷🇴', 4.9, 128, 150, 40, '15 years of holistic practice focusing on emotional balance and lunar guidance. I help people reconnect with their inner wisdom through astrological insights.', 15, 'specialist-1', true, ARRAY['Romanian', 'English'], '2024-01-15'),
        ('2', 'Marcus', 'Holistic Therapist', ARRAY['Therapy', 'Mindfulness', 'Life Coaching'], 'USA', '🇺🇸', 4.8, 96, 120, 55, 'Compassionate therapist specializing in mindfulness-based approaches to emotional wellness and personal transformation.', 12, 'specialist-2', true, ARRAY['English', 'Spanish'], '2024-03-20'),
        ('3', 'Sophia', 'Numerologist', ARRAY['Numerology', 'Life Path', 'Career Guidance'], 'Greece', '🇬🇷', 4.9, 142, 200, 35, 'Expert in numerology with a focus on life path discovery and career alignment through numbers and cosmic patterns.', 18, 'specialist-3', true, ARRAY['Greek', 'English'], '2023-11-10'),
        ('4', 'Kai', 'Reiki Master', ARRAY['Reiki', 'Energy Healing', 'Chakra Balance'], 'Japan', '🇯🇵', 5.0, 87, 95, 50, 'Traditional Reiki master offering energy healing sessions to restore balance, clarity, and inner peace.', 10, 'specialist-4', true, ARRAY['Japanese', 'English'], '2024-06-05')
        ON CONFLICT (id) DO NOTHING;
    """)
    
    # Insert sample reviews
    op.execute("""
        INSERT INTO reviews (id, specialist_id, user_name, rating, comment, date)
        VALUES
        ('1', '1', 'Emma', 5, 'Raluca helped me understand my moon cycle patterns. Truly transformative session.', '2025-09-15'),
        ('2', '1', 'Oliver', 5, 'Her insights were incredibly accurate and deeply resonant. Highly recommend!', '2025-09-10')
        ON CONFLICT (id) DO NOTHING;
    """)


def downgrade() -> None:
    op.execute("DELETE FROM reviews WHERE id IN ('1', '2')")
    op.execute("DELETE FROM specialists WHERE id IN ('1', '2', '3', '4')")
