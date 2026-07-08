from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database.database import get_db
from pydantic import BaseModel
from typing import List

router = APIRouter(
    prefix="/profile",
    tags=["Profile & Premium"]
)

# --- Schemas ---
class ProfileResponse(BaseModel):
    user_id: int
    name: str
    is_premium: bool
    followers_count: int
    following_count: int
    recipes_count: int

class NotificationResponse(BaseModel):
    id: int
    title: str
    body: str
    time_ago: str

# --- APIs ---
@router.get("/", response_model=ProfileResponse)
def get_profile(db: Session = Depends(get_db)):
    """
    Get user profile details (Mock implementation for now)
    """
    return ProfileResponse(
        user_id=1,
        name="Ronak",
        is_premium=True,
        followers_count=1200,
        following_count=45,
        recipes_count=12
    )

@router.post("/upgrade")
def upgrade_to_premium(db: Session = Depends(get_db)):
    """
    Upgrade user to premium (Mock implementation)
    """
    return {"message": "Successfully upgraded to CookMate Premium!"}

@router.get("/notifications", response_model=List[NotificationResponse])
def get_notifications(db: Session = Depends(get_db)):
    """
    Get user notifications (Mock implementation)
    """
    return [
        NotificationResponse(id=1, title="New Recipe Available!", body="Check out the new healthy salad recipe.", time_ago="2 hours ago"),
        NotificationResponse(id=2, title="Meal Plan Reminder", body="Don't forget to cook Paneer Tikka tonight!", time_ago="5 hours ago"),
        NotificationResponse(id=3, title="Subscription Renewed", body="Your CookMate Premium has been renewed.", time_ago="1 day ago"),
    ]
