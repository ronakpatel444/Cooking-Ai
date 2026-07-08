from pydantic import BaseModel
from typing import List, Optional

class IngredientBase(BaseModel):
    name: str
    quantity: str

class IngredientCreate(IngredientBase):
    pass

class IngredientResponse(IngredientBase):
    id: int
    
    class Config:
        orm_mode = True

class RecipeStepBase(BaseModel):
    step_number: int
    instruction: str

class RecipeStepCreate(RecipeStepBase):
    pass

class RecipeStepResponse(RecipeStepBase):
    id: int
    
    class Config:
        orm_mode = True

class RecipeBase(BaseModel):
    title: str
    description: Optional[str] = None
    image_url: Optional[str] = None
    cooking_time: Optional[int] = 0
    difficulty: Optional[str] = "Medium"
    serving_size: Optional[int] = 1
    calories: Optional[float] = 0.0
    protein: Optional[float] = 0.0
    fat: Optional[float] = 0.0
    carbs: Optional[float] = 0.0
    is_premium: Optional[bool] = False

class RecipeCreate(RecipeBase):
    ingredients: List[IngredientCreate]
    steps: List[RecipeStepCreate]

class RecipeResponse(RecipeBase):
    id: int
    ingredients: List[IngredientResponse]
    steps: List[RecipeStepResponse]
    
    class Config:
        orm_mode = True
