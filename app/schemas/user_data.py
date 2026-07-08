from pydantic import BaseModel
from typing import List, Optional
from datetime import date
from .recipe import RecipeResponse

# Favorites
class FavoriteBase(BaseModel):
    recipe_id: int

class FavoriteCreate(FavoriteBase):
    pass

class FavoriteResponse(FavoriteBase):
    id: int
    user_id: int
    recipe: Optional[RecipeResponse] = None

    class Config:
        orm_mode = True

# Pantry
class PantryItemBase(BaseModel):
    ingredient_name: str
    quantity: str
    category: Optional[str] = "General"

class PantryItemCreate(PantryItemBase):
    pass

class PantryItemResponse(PantryItemBase):
    id: int
    user_id: int

    class Config:
        orm_mode = True

# Meal Plan
class MealPlanBase(BaseModel):
    recipe_id: int
    date: date
    meal_type: str

class MealPlanCreate(MealPlanBase):
    pass

class MealPlanResponse(MealPlanBase):
    id: int
    user_id: int
    recipe: Optional[RecipeResponse] = None

    class Config:
        orm_mode = True
