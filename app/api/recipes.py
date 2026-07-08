from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.database.database import get_db
from app.models.recipe import Recipe, Ingredient, RecipeStep
from app.schemas.recipe import RecipeCreate, RecipeResponse

router = APIRouter(
    prefix="/recipes",
    tags=["Recipes"]
)

@router.get("/", response_model=List[RecipeResponse])
def get_recipes(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    recipes = db.query(Recipe).offset(skip).limit(limit).all()
    return recipes

@router.get("/search", response_model=List[RecipeResponse])
def search_recipes(query: str, db: Session = Depends(get_db)):
    """
    Search recipes by title or ingredients.
    """
    recipes = db.query(Recipe).filter(Recipe.title.ilike(f"%{query}%")).all()
    return recipes

@router.get("/{recipe_id}", response_model=RecipeResponse)
def get_recipe(recipe_id: int, db: Session = Depends(get_db)):
    recipe = db.query(Recipe).filter(Recipe.id == recipe_id).first()
    if not recipe:
        raise HTTPException(status_code=404, detail="Recipe not found")
    return recipe

@router.post("/", response_model=RecipeResponse, status_code=status.HTTP_201_CREATED)
def create_recipe(recipe: RecipeCreate, db: Session = Depends(get_db)):
    # Create the Recipe
    db_recipe = Recipe(
        title=recipe.title,
        description=recipe.description,
        image_url=recipe.image_url,
        cooking_time=recipe.cooking_time,
        difficulty=recipe.difficulty,
        serving_size=recipe.serving_size,
        calories=recipe.calories,
        protein=recipe.protein,
        fat=recipe.fat,
        carbs=recipe.carbs,
        is_premium=recipe.is_premium
    )
    db.add(db_recipe)
    db.commit()
    db.refresh(db_recipe)
    
    # Add Ingredients
    for ing in recipe.ingredients:
        db_ing = Ingredient(
            recipe_id=db_recipe.id,
            name=ing.name,
            quantity=ing.quantity
        )
        db.add(db_ing)
        
    # Add Steps
    for step in recipe.steps:
        db_step = RecipeStep(
            recipe_id=db_recipe.id,
            step_number=step.step_number,
            instruction=step.instruction
        )
        db.add(db_step)
        
    db.commit()
    db.refresh(db_recipe)
    return db_recipe

# Additional endpoints (PUT, DELETE, Search) can be added here
