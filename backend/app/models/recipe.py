from sqlalchemy import Column, Integer, String, Float, Boolean, ForeignKey, Text, Table
from sqlalchemy.orm import relationship
from app.database.database import Base

# Many-to-Many relationship table for Recipe and Tags/Categories could be added later
# For MVP, we'll keep it simple

class Recipe(Base):
    __tablename__ = "recipes"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True, nullable=False)
    description = Column(Text, nullable=True)
    image_url = Column(String, nullable=True)
    
    cooking_time = Column(Integer, default=0) # in minutes
    difficulty = Column(String, default="Medium") # Easy, Medium, Hard
    serving_size = Column(Integer, default=1)
    
    # Nutritional Info
    calories = Column(Float, default=0.0)
    protein = Column(Float, default=0.0)
    fat = Column(Float, default=0.0)
    carbs = Column(Float, default=0.0)
    
    is_premium = Column(Boolean, default=False)
    
    # Relationships
    ingredients = relationship("Ingredient", back_populates="recipe", cascade="all, delete-orphan")
    steps = relationship("RecipeStep", back_populates="recipe", cascade="all, delete-orphan", order_by="RecipeStep.step_number")

class Ingredient(Base):
    __tablename__ = "ingredients"

    id = Column(Integer, primary_key=True, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id"))
    name = Column(String, nullable=False)
    quantity = Column(String, nullable=False) # e.g., "2 cups", "1 tsp"
    
    recipe = relationship("Recipe", back_populates="ingredients")

class RecipeStep(Base):
    __tablename__ = "recipe_steps"

    id = Column(Integer, primary_key=True, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id"))
    step_number = Column(Integer, nullable=False)
    instruction = Column(Text, nullable=False)
    
    recipe = relationship("Recipe", back_populates="steps")
