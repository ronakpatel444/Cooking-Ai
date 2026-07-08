import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import 'package:image_picker/image_picker.dart';

class CameraScanScreen extends ConsumerStatefulWidget {
  const CameraScanScreen({super.key});

  @override
  ConsumerState<CameraScanScreen> createState() => _CameraScanScreenState();
}

class _CameraScanScreenState extends ConsumerState<CameraScanScreen> {
  bool _isScanning = false;
  bool _scanComplete = false;
  final TextEditingController _correctionController = TextEditingController();

  List<String> _detectedIngredients = [];
  String _aiError = "";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  
  void _startScan() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      _imageFile = File(image.path);
      _isScanning = true;
      _aiError = "";
    });
    
    try {
      final dio = ref.read(dioProvider);
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: "scan.jpg"),
      });

      final response = await dio.post('/ai/scan-image', data: formData);
      
      if (mounted) {
        String aiResponse = response.data['response'] ?? '';
        setState(() {
          _isScanning = false;
          _scanComplete = true;
          
          if (aiResponse.contains("I can't see any food item in the image.")) {
            _aiError = "I can't see any food item in the image.";
            _detectedIngredients = [];
          } else {
            // Parse the AI response into a list
            _detectedIngredients = aiResponse.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _scanComplete = true;
          _aiError = "Failed to connect to AI: $e";
          _detectedIngredients = ['Vadhareli Rotli (Error)'];
        });
      }
    }
  }

  void _addCorrection() {
    final text = _correctionController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _detectedIngredients.clear();
        _detectedIngredients.addAll(text.split(',').map((e) => e.trim()));
      });
      _correctionController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingredients updated!')),
      );
    }
  }

  @override
  void dispose() {
    _correctionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Ingredients'),
      ),
      body: Column(
        children: [
          // Fake Camera Viewfinder
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.black,
            child: _isScanning
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text('Analyzing Image...', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      if (_imageFile != null)
                        Image.file(_imageFile!, fit: BoxFit.cover)
                      else
                        Center(
                          child: Icon(Icons.camera_alt, color: Colors.white.withOpacity(0.5), size: 100),
                        ),
                      if (!_scanComplete)
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ElevatedButton.icon(
                              onPressed: _startScan,
                              icon: const Icon(Icons.camera),
                              label: const Text('Open Camera & Scan'),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          
          if (_scanComplete)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_aiError.isNotEmpty) 
                      Text(_aiError, style: const TextStyle(color: Colors.red)),
                      
                    const Text(
                      'AI Detected:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _detectedIngredients.map((ing) {
                            return Chip(
                              label: Text(ing),
                              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                              onDeleted: () {
                                setState(() {
                                  _detectedIngredients.remove(ing);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Is the AI wrong? Describe the ingredients manually:',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _correctionController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Leftover Roti, Oil, Mustard seeds',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _addCorrection,
                        ),
                      ),
                      onSubmitted: (_) => _addCorrection(),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _detectedIngredients.isEmpty
                          ? null
                          : () {
                              context.push('/ai_result', extra: _detectedIngredients);
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Find Recipes'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
