from google.cloud import speech
from google.cloud import texttospeech
import os

class VoiceService:
    def __init__(self):
        # Assumes GOOGLE_APPLICATION_CREDENTIALS is in env
        try:
            self.speech_client = speech.SpeechClient()
            self.tts_client = texttospeech.TextToSpeechClient()
        except Exception as e:
            print(f"Warning: Google Cloud credentials not found. Voice features will not work. Error: {e}")
            self.speech_client = None
            self.tts_client = None
        
    def transcribe_audio(self, audio_content: bytes, language_code: str = "en-US") -> str:
        """
        Converts speech audio bytes to text using Google Cloud Speech-to-Text.
        Supports en-US, hi-IN, gu-IN based on language_code.
        """
        audio = speech.RecognitionAudio(content=audio_content)
        config = speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
            language_code=language_code,
        )
        
        response = self.speech_client.recognize(config=config, audio=audio)
        
        transcript = ""
        for result in response.results:
            transcript += result.alternatives[0].transcript
            
        return transcript

    def synthesize_speech(self, text: str, language_code: str = "en-US") -> bytes:
        """
        Converts text to speech audio bytes using Google Cloud Text-to-Speech.
        """
        synthesis_input = texttospeech.SynthesisInput(text=text)
        
        voice = texttospeech.VoiceSelectionParams(
            language_code=language_code,
            ssml_gender=texttospeech.SsmlVoiceGender.NEUTRAL
        )
        
        audio_config = texttospeech.AudioConfig(
            audio_encoding=texttospeech.AudioEncoding.MP3
        )
        
        response = self.tts_client.synthesize_speech(
            input=synthesis_input, voice=voice, audio_config=audio_config
        )
        
        return response.audio_content

voice_service = VoiceService()
