from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Date
from sqlalchemy.orm import relationship
from app.database.database import Base

class Favorite(Base):
    __tablename__ = "favorites"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True) # Assuming a simple integer ID for now, connect to User model later
    recipe_id = Column(Integer, ForeignKey("recipes.id"))
    
    recipe = relationship("Recipe")

class PantryItem(Base):
    __tablename__ = "pantry_items"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    ingredient_name = Column(String, index=True)
    quantity = Column(String)
    category = Column(String, default="General") # e.g., Spices, Dairy, Vegetables

class MealPlan(Base):
    __tablename__ = "meal_plans"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    recipe_id = Column(Integer, ForeignKey("recipes.id"))
    date = Column(Date, index=True)
    meal_type = Column(String) # Breakfast, Lunch, Dinner, Snack
    
    recipe = relationship("Recipe")
