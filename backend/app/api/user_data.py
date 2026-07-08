from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from datetime import date
from app.database.database import get_db
from app.models.user_data import Favorite, PantryItem, MealPlan
from app.schemas.user_data import (
    FavoriteCreate, FavoriteResponse,
    PantryItemCreate, PantryItemResponse,
    MealPlanCreate, MealPlanResponse
)

router = APIRouter(
    prefix="/user",
    tags=["User Data"]
)

# --- Favorites ---
@router.post("/favorites", response_model=FavoriteResponse)
def add_favorite(fav: FavoriteCreate, db: Session = Depends(get_db)):
    db_fav = Favorite(user_id=1, recipe_id=fav.recipe_id) # Hardcoded user_id=1 for MVP
    db.add(db_fav)
    db.commit()
    db.refresh(db_fav)
    return db_fav

@router.get("/favorites", response_model=List[FavoriteResponse])
def get_favorites(db: Session = Depends(get_db)):
    return db.query(Favorite).filter(Favorite.user_id == 1).all()

# --- Smart Pantry ---
@router.post("/pantry", response_model=PantryItemResponse)
def add_pantry_item(item: PantryItemCreate, db: Session = Depends(get_db)):
    db_item = PantryItem(
        user_id=1,
        ingredient_name=item.ingredient_name,
        quantity=item.quantity,
        category=item.category
    )
    db.add(db_item)
    db.commit()
    db.refresh(db_item)
    return db_item

@router.get("/pantry", response_model=List[PantryItemResponse])
def get_pantry(db: Session = Depends(get_db)):
    return db.query(PantryItem).filter(PantryItem.user_id == 1).all()

# --- Meal Planner ---
@router.post("/meal-plan", response_model=MealPlanResponse)
def add_meal_plan(plan: MealPlanCreate, db: Session = Depends(get_db)):
    db_plan = MealPlan(
        user_id=1,
        recipe_id=plan.recipe_id,
        date=plan.date,
        meal_type=plan.meal_type
    )
    db.add(db_plan)
    db.commit()
    db.refresh(db_plan)
    return db_plan

@router.get("/meal-plan", response_model=List[MealPlanResponse])
def get_meal_plan(start_date: date, end_date: date, db: Session = Depends(get_db)):
    return db.query(MealPlan).filter(
        MealPlan.user_id == 1,
        MealPlan.date >= start_date,
        MealPlan.date <= end_date
    ).all()
