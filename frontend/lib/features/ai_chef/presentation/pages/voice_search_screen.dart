import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../../../core/network/dio_client.dart';

class VoiceSearchScreen extends ConsumerStatefulWidget {
  const VoiceSearchScreen({super.key});

  @override
  ConsumerState<VoiceSearchScreen> createState() => _VoiceSearchScreenState();
}

class _VoiceSearchScreenState extends ConsumerState<VoiceSearchScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  
  bool _isListening = false;
  bool _isLoadingResponse = false;
  bool _speechEnabled = false;
  String _transcript = "Tap the microphone and start speaking...";
  String _aiResponse = "";
  String _lastProcessedTranscript = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize(
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
          setState(() => _isListening = false);
          if (_transcript.isNotEmpty && 
              _transcript != "Tap the microphone and start speaking..." && 
              _transcript != "Listening...") {
            _getAiResponse(_transcript);
          }
        }
      },
      onError: (val) {
        print('onError: $val');
        setState(() => _isListening = false);
      },
    );
    setState(() {});
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }

  void _getAiResponse(String message) async {
    if (message.trim().isEmpty || message == _lastProcessedTranscript) return;
    
    _lastProcessedTranscript = message;
    
    setState(() {
      _isLoadingResponse = true;
    });
    
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.post('/ai/chat', data: {
        'message': "I am telling my AI chef: $message. Please reply in the exact same language as my prompt and suggest a recipe quickly."
      });
      
      if (mounted) {
        setState(() {
          _isLoadingResponse = false;
          _aiResponse = response.data['response'] ?? 'No response from AI.';
        });
        _flutterTts.speak(_aiResponse);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingResponse = false;
          _aiResponse = "Error connecting to AI Chef: $e";
        });
      }
    }
  }

  void _toggleListening() async {
    if (_isLoadingResponse) return;
    
    if (_isListening) {
      setState(() => _isListening = false);
      _speech.stop();
    } else {
      _flutterTts.stop();
      if (_speechEnabled) {
        setState(() {
          _isListening = true;
          _aiResponse = "";
          _transcript = "Listening...";
        });
        
        _speech.listen(
          onResult: (val) {
            setState(() {
              _transcript = val.recognizedWords;
            });
          },
        );
      } else {
        // Try re-initializing if it was previously denied/unavailable
        _initSpeech();
        setState(() {
          _transcript = "Speech recognition denied or not available. Trying to reconnect...";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Search'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_aiResponse.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _aiResponse,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: _isLoadingResponse
                        ? const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('AI Chef is thinking...'),
                            ],
                          )
                        : Text(
                            _transcript,
                            style: const TextStyle(fontSize: 20, height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _toggleListening,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isListening
                            ? Colors.red.withOpacity(0.5 + (_animationController.value * 0.3))
                            : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        boxShadow: _isListening
                            ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.5),
                                  blurRadius: _animationController.value * 20,
                                  spreadRadius: _animationController.value * 10,
                                )
                              ]
                            : null,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        size: 64,
                        color: _isListening ? Colors.white : Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
