import os
from sqlalchemy.orm import Session
from app.database.database import engine, Base, SessionLocal
from app.models.recipe import Recipe, Ingredient, RecipeStep

def seed_db():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    
    # Check if we already have recipes
    if db.query(Recipe).count() > 0:
        print("Database already seeded with recipes.")
        db.close()
        return

    recipes_data = [
        {
            "title": "Paneer Butter Masala",
            "description": "A rich and creamy North Indian curry made with paneer and tomato-based sauce.",
            "image_url": "https://images.unsplash.com/photo-1565557623262-b51c2513a641?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 45,
            "difficulty": "Medium",
            "serving_size": 4,
            "calories": 450,
            "ingredients": [
                {"name": "Paneer", "quantity": "250g"},
                {"name": "Tomato Puree", "quantity": "1 cup"},
                {"name": "Heavy Cream", "quantity": "1/2 cup"},
                {"name": "Butter", "quantity": "2 tbsp"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Heat butter in a pan and saute tomato puree."},
                {"step_number": 2, "instruction": "Add spices and cook until oil separates."},
                {"step_number": 3, "instruction": "Add paneer cubes and simmer for 5 minutes."},
                {"step_number": 4, "instruction": "Stir in cream and serve hot."}
            ]
        },
        {
            "title": "Healthy Avocado Quinoa Salad",
            "description": "A refreshing and protein-packed salad for a healthy lunch.",
            "image_url": "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 15,
            "difficulty": "Easy",
            "serving_size": 2,
            "calories": 320,
            "ingredients": [
                {"name": "Quinoa (cooked)", "quantity": "1 cup"},
                {"name": "Avocado", "quantity": "1 medium"},
                {"name": "Cherry Tomatoes", "quantity": "1/2 cup"},
                {"name": "Lemon Juice", "quantity": "2 tbsp"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Dice avocado and halve cherry tomatoes."},
                {"step_number": 2, "instruction": "Toss cooked quinoa, avocado, and tomatoes in a bowl."},
                {"step_number": 3, "instruction": "Drizzle with lemon juice and season to taste."}
            ]
        },
        {
            "title": "Gujarati Khandvi",
            "description": "A savory, tightly rolled snack made of besan and yogurt.",
            "image_url": "https://images.unsplash.com/photo-1605335154332-9a572a188ba9?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 30,
            "difficulty": "Hard",
            "serving_size": 3,
            "calories": 210,
            "ingredients": [
                {"name": "Besan (Gram Flour)", "quantity": "1 cup"},
                {"name": "Yogurt", "quantity": "1 cup"},
                {"name": "Mustard Seeds", "quantity": "1 tsp"},
                {"name": "Green Chilies", "quantity": "2"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Mix besan, yogurt, and water to make a smooth batter."},
                {"step_number": 2, "instruction": "Cook on low heat until it thickens."},
                {"step_number": 3, "instruction": "Spread thinly on a flat surface, cool, and roll."},
                {"step_number": 4, "instruction": "Temper with mustard seeds and green chilies."}
            ]
        },
        {
            "title": "Classic Margherita Pizza",
            "description": "Simple, fresh, and classic Italian pizza.",
            "image_url": "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 25,
            "difficulty": "Medium",
            "serving_size": 2,
            "calories": 500,
            "ingredients": [
                {"name": "Pizza Dough", "quantity": "1 base"},
                {"name": "Tomato Sauce", "quantity": "1/2 cup"},
                {"name": "Mozzarella Cheese", "quantity": "1 cup"},
                {"name": "Fresh Basil", "quantity": "A handful"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Spread tomato sauce over the pizza dough."},
                {"step_number": 2, "instruction": "Top with mozzarella cheese."},
                {"step_number": 3, "instruction": "Bake at 450F for 10-12 minutes."},
                {"step_number": 4, "instruction": "Garnish with fresh basil before serving."}
            ]
        },
        {
            "title": "Spicy Ramen Noodles",
            "description": "A quick, spicy, and comforting bowl of ramen.",
            "image_url": "https://images.unsplash.com/photo-1552611052-33e04de081de?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 15,
            "difficulty": "Easy",
            "serving_size": 1,
            "calories": 380,
            "ingredients": [
                {"name": "Ramen Noodles", "quantity": "1 pack"},
                {"name": "Chili Oil", "quantity": "1 tbsp"},
                {"name": "Soft Boiled Egg", "quantity": "1"},
                {"name": "Green Onions", "quantity": "2 tbsp"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Boil noodles according to package instructions."},
                {"step_number": 2, "instruction": "Mix chili oil and seasoning in the broth."},
                {"step_number": 3, "instruction": "Top with egg and green onions."}
            ]
        },
        {
            "title": "Dal Tadka",
            "description": "Comforting yellow lentils tempered with ghee and spices.",
            "image_url": "https://images.unsplash.com/photo-1546833999-b9f581a1996d?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 40,
            "difficulty": "Easy",
            "serving_size": 4,
            "calories": 250,
            "ingredients": [
                {"name": "Toor Dal", "quantity": "1 cup"},
                {"name": "Ghee", "quantity": "2 tbsp"},
                {"name": "Cumin Seeds", "quantity": "1 tsp"},
                {"name": "Garlic", "quantity": "4 cloves"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Pressure cook the dal until soft and mushy."},
                {"step_number": 2, "instruction": "Heat ghee in a pan, add cumin and chopped garlic."},
                {"step_number": 3, "instruction": "Pour the tempering over the cooked dal and simmer."}
            ]
        },
        {
            "title": "Grilled Lemon Herb Salmon",
            "description": "Flaky grilled salmon packed with fresh citrus and herb flavors.",
            "image_url": "https://images.unsplash.com/photo-1485921325833-c519f76c4927?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 20,
            "difficulty": "Medium",
            "serving_size": 2,
            "calories": 410,
            "ingredients": [
                {"name": "Salmon Fillet", "quantity": "2 pieces"},
                {"name": "Lemon Juice", "quantity": "2 tbsp"},
                {"name": "Olive Oil", "quantity": "1 tbsp"},
                {"name": "Mixed Herbs", "quantity": "1 tbsp"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Marinate salmon with lemon juice, oil, and herbs for 15 mins."},
                {"step_number": 2, "instruction": "Grill on medium-high heat for 4-5 minutes per side."},
                {"step_number": 3, "instruction": "Serve with a side of steamed veggies."}
            ]
        },
        {
            "title": "Berry Smoothie Bowl",
            "description": "A thick, nutritious breakfast bowl topped with fresh fruits and seeds.",
            "image_url": "https://images.unsplash.com/photo-1494597564530-871f2b93ac55?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 10,
            "difficulty": "Easy",
            "serving_size": 1,
            "calories": 280,
            "ingredients": [
                {"name": "Mixed Frozen Berries", "quantity": "1 cup"},
                {"name": "Banana", "quantity": "1"},
                {"name": "Almond Milk", "quantity": "1/2 cup"},
                {"name": "Chia Seeds", "quantity": "1 tbsp"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Blend berries, half the banana, and milk until thick."},
                {"step_number": 2, "instruction": "Pour into a bowl."},
                {"step_number": 3, "instruction": "Top with sliced banana and chia seeds."}
            ]
        },
        {
            "title": "Chole Bhature",
            "description": "Spicy chickpea curry served with deep-fried bread.",
            "image_url": "https://images.unsplash.com/photo-1626132647523-66f55c34c05f?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 60,
            "difficulty": "Hard",
            "serving_size": 2,
            "calories": 650,
            "ingredients": [
                {"name": "Chickpeas (soaked)", "quantity": "1.5 cups"},
                {"name": "Onion", "quantity": "1 large"},
                {"name": "Chole Masala", "quantity": "2 tbsp"},
                {"name": "Maida (for bhature)", "quantity": "2 cups"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Boil chickpeas until tender."},
                {"step_number": 2, "instruction": "Prepare gravy with onion, tomato, and spices, then mix chickpeas."},
                {"step_number": 3, "instruction": "Knead maida with yogurt, let it rest, then roll and deep fry for bhature."}
            ]
        },
        {
            "title": "Spaghetti Carbonara",
            "description": "A classic Italian pasta dish made with eggs, cheese, and pancetta.",
            "image_url": "https://images.unsplash.com/photo-1612874742237-6526221588e3?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 25,
            "difficulty": "Medium",
            "serving_size": 2,
            "calories": 550,
            "ingredients": [
                {"name": "Spaghetti", "quantity": "200g"},
                {"name": "Pancetta", "quantity": "100g"},
                {"name": "Eggs", "quantity": "2 large"},
                {"name": "Parmesan Cheese", "quantity": "1/2 cup"}
            ],
            "steps": [
                {"step_number": 1, "instruction": "Cook pasta in salted water until al dente."},
                {"step_number": 2, "instruction": "Fry pancetta until crisp."},
                {"step_number": 3, "instruction": "Mix eggs and cheese, then toss with hot pasta off the heat to create a creamy sauce."}
            ]
        },
        # Adding 11 more to reach 21
        {
            "title": "Vegetable Stir Fry",
            "description": "Quick and healthy mixed vegetables tossed in soy sauce and garlic.",
            "image_url": "https://images.unsplash.com/photo-1512058564366-18510be2db19?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 15,
            "difficulty": "Easy",
            "serving_size": 2,
            "calories": 200,
            "ingredients": [{"name": "Mixed Veggies", "quantity": "2 cups"}, {"name": "Soy Sauce", "quantity": "2 tbsp"}],
            "steps": [{"step_number": 1, "instruction": "Stir fry veggies on high heat."}, {"step_number": 2, "instruction": "Add soy sauce and serve."}]
        },
        {
            "title": "Butter Chicken",
            "description": "Iconic Indian chicken curry in a rich tomato and butter sauce.",
            "image_url": "https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 50,
            "difficulty": "Medium",
            "serving_size": 4,
            "calories": 600,
            "ingredients": [{"name": "Chicken", "quantity": "500g"}, {"name": "Butter", "quantity": "3 tbsp"}, {"name": "Tomato Puree", "quantity": "1.5 cups"}],
            "steps": [{"step_number": 1, "instruction": "Marinate and cook chicken."}, {"step_number": 2, "instruction": "Simmer in butter tomato sauce."}]
        },
        {
            "title": "French Toast",
            "description": "Sweet and fluffy breakfast favorite with maple syrup.",
            "image_url": "https://images.unsplash.com/photo-1484723091792-c195600cb33d?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 15,
            "difficulty": "Easy",
            "serving_size": 2,
            "calories": 350,
            "ingredients": [{"name": "Bread", "quantity": "4 slices"}, {"name": "Eggs", "quantity": "2"}, {"name": "Milk", "quantity": "1/4 cup"}],
            "steps": [{"step_number": 1, "instruction": "Dip bread in egg-milk mixture."}, {"step_number": 2, "instruction": "Cook on a buttered skillet until golden."}]
        },
        {
            "title": "Chicken Tikka Masala",
            "description": "Roasted chicken chunks in a spicy sauce.",
            "image_url": "https://images.unsplash.com/photo-1565557623262-b51c2513a641?q=80&w=600&auto=format&fit=crop", # reusing image for simplicity
            "cooking_time": 45,
            "difficulty": "Medium",
            "serving_size": 3,
            "calories": 520,
            "ingredients": [{"name": "Chicken Tikka", "quantity": "400g"}, {"name": "Onion Tomato Masala", "quantity": "2 cups"}],
            "steps": [{"step_number": 1, "instruction": "Make base masala."}, {"step_number": 2, "instruction": "Add chicken tikka and simmer."}]
        },
        {
            "title": "Dhokla",
            "description": "Spongy, savory steamed cake made from gram flour.",
            "image_url": "https://images.unsplash.com/photo-1589301760014-d929f39ce9b1?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 30,
            "difficulty": "Medium",
            "serving_size": 4,
            "calories": 180,
            "ingredients": [{"name": "Besan", "quantity": "1 cup"}, {"name": "Eno", "quantity": "1 tsp"}],
            "steps": [{"step_number": 1, "instruction": "Steam besan batter."}, {"step_number": 2, "instruction": "Add sweet and spicy tempering."}]
        },
        {
            "title": "Mushroom Risotto",
            "description": "Creamy Italian rice dish with earthy mushrooms.",
            "image_url": "https://images.unsplash.com/photo-1476124369491-e7addf5db371?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 40,
            "difficulty": "Medium",
            "serving_size": 2,
            "calories": 480,
            "ingredients": [{"name": "Arborio Rice", "quantity": "1 cup"}, {"name": "Mushrooms", "quantity": "200g"}],
            "steps": [{"step_number": 1, "instruction": "Saute mushrooms."}, {"step_number": 2, "instruction": "Slowly cook rice adding broth ladles."}]
        },
        {
            "title": "Beef Tacos",
            "description": "Crispy tacos filled with seasoned ground beef and cheese.",
            "image_url": "https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 20,
            "difficulty": "Easy",
            "serving_size": 3,
            "calories": 450,
            "ingredients": [{"name": "Ground Beef", "quantity": "300g"}, {"name": "Taco Shells", "quantity": "6"}],
            "steps": [{"step_number": 1, "instruction": "Brown the beef with taco seasoning."}, {"step_number": 2, "instruction": "Fill shells and add toppings."}]
        },
        {
            "title": "Greek Salad",
            "description": "Fresh and tangy salad with feta cheese and olives.",
            "image_url": "https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 10,
            "difficulty": "Easy",
            "serving_size": 2,
            "calories": 250,
            "ingredients": [{"name": "Cucumber", "quantity": "1"}, {"name": "Feta Cheese", "quantity": "100g"}, {"name": "Olives", "quantity": "1/4 cup"}],
            "steps": [{"step_number": 1, "instruction": "Chop veggies."}, {"step_number": 2, "instruction": "Toss with olive oil and oregano."}]
        },
        {
            "title": "Chocolate Lava Cake",
            "description": "Decadent dessert with a gooey, molten chocolate center.",
            "image_url": "https://images.unsplash.com/photo-1606890737304-57a1ca8a5b62?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 25,
            "difficulty": "Hard",
            "serving_size": 2,
            "calories": 550,
            "ingredients": [{"name": "Dark Chocolate", "quantity": "100g"}, {"name": "Eggs", "quantity": "2"}],
            "steps": [{"step_number": 1, "instruction": "Melt chocolate and butter."}, {"step_number": 2, "instruction": "Fold in eggs and flour, bake at high heat briefly."}]
        },
        {
            "title": "Pancakes with Maple Syrup",
            "description": "Fluffy homemade pancakes stacked high.",
            "image_url": "https://images.unsplash.com/photo-1528207776546-ac21efa48b1b?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 20,
            "difficulty": "Easy",
            "serving_size": 2,
            "calories": 400,
            "ingredients": [{"name": "Flour", "quantity": "1 cup"}, {"name": "Milk", "quantity": "1 cup"}],
            "steps": [{"step_number": 1, "instruction": "Mix dry and wet ingredients."}, {"step_number": 2, "instruction": "Cook ladles of batter on a hot griddle."}]
        },
        {
            "title": "Sushi Rolls",
            "description": "Homemade maki sushi with fresh salmon and avocado.",
            "image_url": "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?q=80&w=600&auto=format&fit=crop",
            "cooking_time": 50,
            "difficulty": "Hard",
            "serving_size": 2,
            "calories": 320,
            "ingredients": [{"name": "Sushi Rice", "quantity": "1 cup"}, {"name": "Nori Sheets", "quantity": "2"}],
            "steps": [{"step_number": 1, "instruction": "Prepare seasoned sushi rice."}, {"step_number": 2, "instruction": "Roll with fish and avocado using a bamboo mat."}]
        }
    ]

    for data in recipes_data:
        recipe = Recipe(
            title=data['title'],
            description=data['description'],
            image_url=data['image_url'],
            cooking_time=data['cooking_time'],
            difficulty=data['difficulty'],
            serving_size=data['serving_size'],
            calories=data['calories']
        )
        db.add(recipe)
        db.flush() # get ID
        
        for ing in data['ingredients']:
            db.add(Ingredient(recipe_id=recipe.id, name=ing['name'], quantity=ing['quantity']))
            
        for step in data['steps']:
            db.add(RecipeStep(recipe_id=recipe.id, step_number=step['step_number'], instruction=step['instruction']))

    db.commit()
    print(f"Seeded {len(recipes_data)} recipes successfully.")
    db.close()

if __name__ == "__main__":
    seed_db()
