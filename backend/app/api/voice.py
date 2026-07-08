from fastapi import APIRouter, HTTPException, UploadFile, File, Form, Response
from pydantic import BaseModel
from app.ai.voice import voice_service

router = APIRouter(
    prefix="/voice",
    tags=["Voice Services"]
)

class TTSRequest(BaseModel):
    text: str
    language_code: str = "en-US"

@router.post("/synthesize")
def synthesize_speech(request: TTSRequest):
    """
    Converts text into audio (MP3).
    """
    try:
        audio_content = voice_service.synthesize_speech(request.text, request.language_code)
        return Response(content=audio_content, media_type="audio/mpeg")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/transcribe")
async def transcribe_audio(
    file: UploadFile = File(...),
    language_code: str = Form("en-US")
):
    """
    Converts uploaded audio file into text.
    """
    try:
        audio_bytes = await file.read()
        transcript = voice_service.transcribe_audio(audio_bytes, language_code)
        return {"transcript": transcript}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
