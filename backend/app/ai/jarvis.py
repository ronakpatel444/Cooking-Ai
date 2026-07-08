import os
from google import genai
from google.genai import types
from sqlalchemy.orm import Session
from app.models.recipe import Recipe
from dotenv import load_dotenv

load_dotenv()

# Initialize Gemini Client
# Assumes GEMINI_API_KEY is in the environment
client = genai.Client()

class JarvisAI:
    def __init__(self):
        self.model = 'gemini-3.5-flash'

    def process_chat(self, user_message: str, db: Session) -> str:
        """
        Processes a chat message. 
        First, tries to answer using local database knowledge.
        If local knowledge is insufficient, falls back to Google Gemini.
        """
        # MVP Local DB Check Strategy:
        # If the user asks about a recipe by name, try to find it in the DB.
        # This is a very simplified "Jarvis" logic.
        search_terms = user_message.lower().split()
        if "recipe" in search_terms or "how to make" in user_message.lower():
            # Try to find a matching recipe in DB
            recipes = db.query(Recipe).all()
            for recipe in recipes:
                if recipe.title.lower() in user_message.lower():
                    return f"I found a recipe for {recipe.title} in our database! It takes {recipe.cooking_time} minutes to cook."

        # Fallback to Gemini
        return self._generate_gemini_response(user_message)

    def _generate_gemini_response(self, prompt: str) -> str:
        try:
            detailed_prompt = (
                f"{prompt}\n\n"
                "IMPORTANT INSTRUCTION: When providing a recipe, provide highly detailed step-by-step instructions (at least 7-10 steps) "
                "with proper techniques, explanations, and precise measurements. Do NOT just give 3-5 brief steps. Be as descriptive as possible."
            )
            response = client.models.generate_content(
                model=self.model,
                contents=detailed_prompt,
            )
            return response.text
        except Exception as e:
            return f"I'm sorry, I encountered an error: {str(e)}"

    def analyze_image_for_recipe(self, image_data: bytes, mime_type: str) -> str:
        """
        Uses Gemini Vision to analyze an image (e.g., ingredients) and suggest a recipe.
        """
        try:
            prompt = (
                "Analyze this image. If it contains food ingredients or a cooked dish, list the basic raw ingredients you would detect as a comma-separated list (e.g. Tomato, Onion, Garlic). "
                "CRITICAL: If the image does not contain any food items or ingredients (for example, if it's just a bottle, a person, a pen, etc.), "
                "respond EXACTLY with: 'I can't see any food item in the image.' and nothing else."
            )
            response = client.models.generate_content(
                model=self.model,
                contents=[
                    prompt,
                    types.Part.from_bytes(
                        data=image_data,
                        mime_type=mime_type,
                    )
                ]
            )
            return response.text
        except Exception as e:
             return f"Failed to analyze image: {str(e)}"

jarvis = JarvisAI()
