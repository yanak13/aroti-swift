"""Initial schema

Revision ID: 001_initial
Revises: 
Create Date: 2024-01-01 00:00:00.000000

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = '001_initial'
down_revision = None
branch_labels = None
depends_on = None


def upgrade() -> None:
    # Create specialists table
    op.create_table(
        'specialists',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('specialty', sa.String(), nullable=False),
        sa.Column('categories', postgresql.ARRAY(sa.String()), nullable=True),
        sa.Column('country', sa.String(), nullable=True),
        sa.Column('country_flag', sa.String(), nullable=True),
        sa.Column('rating', sa.Float(), nullable=True),
        sa.Column('review_count', sa.Integer(), nullable=True),
        sa.Column('session_count', sa.Integer(), nullable=True),
        sa.Column('price', sa.Integer(), nullable=False),
        sa.Column('bio', sa.Text(), nullable=True),
        sa.Column('years_of_practice', sa.Integer(), nullable=True),
        sa.Column('photo', sa.String(), nullable=True),
        sa.Column('available', sa.Boolean(), nullable=True),
        sa.Column('languages', postgresql.ARRAY(sa.String()), nullable=True),
        sa.Column('added_date', sa.String(), nullable=True),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_specialists_id'), 'specialists', ['id'], unique=False)
    
    # Create users table
    op.create_table(
        'users',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('email', sa.String(), nullable=True),
        sa.Column('sun_sign', sa.String(), nullable=True),
        sa.Column('moon_sign', sa.String(), nullable=True),
        sa.Column('birth_date', sa.Date(), nullable=True),
        sa.Column('birth_time', sa.DateTime(), nullable=True),
        sa.Column('birth_location', sa.String(), nullable=True),
        sa.Column('traits', postgresql.ARRAY(sa.String()), nullable=True),
        sa.Column('is_premium', sa.Boolean(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_users_id'), 'users', ['id'], unique=False)
    op.create_index(op.f('ix_users_email'), 'users', ['email'], unique=True)
    
    # Create sessions table
    op.create_table(
        'sessions',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('specialist_id', sa.String(), nullable=False),
        sa.Column('user_id', sa.String(), nullable=False),
        sa.Column('specialist_name', sa.String(), nullable=False),
        sa.Column('specialist_photo', sa.String(), nullable=True),
        sa.Column('specialty', sa.String(), nullable=True),
        sa.Column('date', sa.String(), nullable=False),
        sa.Column('time', sa.String(), nullable=False),
        sa.Column('duration', sa.Integer(), nullable=True),
        sa.Column('price', sa.Integer(), nullable=False),
        sa.Column('status', sa.String(), nullable=True),
        sa.Column('meeting_link', sa.String(), nullable=True),
        sa.Column('preparation_notes', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['specialist_id'], ['specialists.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_sessions_id'), 'sessions', ['id'], unique=False)
    op.create_index(op.f('ix_sessions_user_id'), 'sessions', ['user_id'], unique=False)
    
    # Create reviews table
    op.create_table(
        'reviews',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('specialist_id', sa.String(), nullable=False),
        sa.Column('user_name', sa.String(), nullable=False),
        sa.Column('rating', sa.Integer(), nullable=False),
        sa.Column('comment', sa.Text(), nullable=True),
        sa.Column('date', sa.String(), nullable=False),
        sa.ForeignKeyConstraint(['specialist_id'], ['specialists.id'], ),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_reviews_id'), 'reviews', ['id'], unique=False)
    op.create_index(op.f('ix_reviews_specialist_id'), 'reviews', ['specialist_id'], unique=False)
    
    # Create user_profiles table
    op.create_table(
        'user_profiles',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('user_id', sa.String(), nullable=False),
        sa.Column('avatar_url', sa.String(), nullable=True),
        sa.Column('bio', sa.Text(), nullable=True),
        sa.Column('preferences', sa.Text(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.Column('updated_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['user_id'], ['users.id'], ),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('user_id')
    )
    op.create_index(op.f('ix_user_profiles_id'), 'user_profiles', ['id'], unique=False)


def downgrade() -> None:
    op.drop_index(op.f('ix_user_profiles_id'), table_name='user_profiles')
    op.drop_table('user_profiles')
    op.drop_index(op.f('ix_reviews_specialist_id'), table_name='reviews')
    op.drop_index(op.f('ix_reviews_id'), table_name='reviews')
    op.drop_table('reviews')
    op.drop_index(op.f('ix_sessions_user_id'), table_name='sessions')
    op.drop_index(op.f('ix_sessions_id'), table_name='sessions')
    op.drop_table('sessions')
    op.drop_index(op.f('ix_users_email'), table_name='users')
    op.drop_index(op.f('ix_users_id'), table_name='users')
    op.drop_table('users')
    op.drop_index(op.f('ix_specialists_id'), table_name='specialists')
    op.drop_table('specialists')
