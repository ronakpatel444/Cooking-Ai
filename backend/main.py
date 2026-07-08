from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.api import auth, recipes, ai_chat, voice, user_data, profile
from app.database.database import engine, Base

# Create tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="AI Recipe App API",
    description="Backend API for the AI Recipe Application",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/static", StaticFiles(directory="static"), name="static")

app.include_router(auth.router)
app.include_router(recipes.router)
app.include_router(ai_chat.router)
app.include_router(voice.router)
app.include_router(user_data.router)
app.include_router(profile.router)

@app.get("/")
def read_root():
    return {"message": "Welcome to AI Recipe App API"}
