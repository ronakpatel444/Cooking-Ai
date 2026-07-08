from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
from pydantic import BaseModel
from app.database.database import get_db
from app.ai.jarvis import jarvis
import io

router = APIRouter(
    prefix="/ai",
    tags=["AI Services"]
)

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    response: str

@router.post("/chat", response_model=ChatResponse)
def chat_with_jarvis(request: ChatRequest, db: Session = Depends(get_db)):
    """
    Send a message to Jarvis AI.
    """
    response_text = jarvis.process_chat(request.message, db)
    return ChatResponse(response=response_text)

@router.post("/scan-image", response_model=ChatResponse)
async def scan_image(file: UploadFile = File(...)):
    """
    Upload an image for Jarvis (Gemini Vision) to analyze.
    """
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File provided is not an image.")
        
    image_bytes = await file.read()
    response_text = jarvis.analyze_image_for_recipe(image_bytes, file.content_type)
    return ChatResponse(response=response_text)
