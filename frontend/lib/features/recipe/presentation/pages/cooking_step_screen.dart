import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import '../../data/models/recipe_model.dart';
import '../../../../l10n/app_localizations.dart';

class CookingStepScreen extends StatefulWidget {
  final RecipeModel? recipe;
  
  const CookingStepScreen({super.key, this.recipe});

  @override
  State<CookingStepScreen> createState() => _CookingStepScreenState();
}

class _CookingStepScreenState extends State<CookingStepScreen> {
  int _currentStep = 0;
  bool _isPlaying = false;
  final FlutterTts flutterTts = FlutterTts();

  List<String> get _steps {
    final l10n = AppLocalizations.of(context)!;
    return [
      l10n.step1,
      l10n.step2,
      l10n.step3,
      l10n.step4,
      l10n.step5,
    ];
  }

  final List<String> _dishImages = [
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80',
    'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800&q=80',
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800&q=80',
  ];

  List<int> _stepsWithImages = [];
  bool _isTtsInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.recipe?.imageUrl != null) {
      _dishImages[0] = widget.recipe!.imageUrl!;
    }
    _pickRandomStepsForImages();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isTtsInitialized) {
      _initTts();
      _isTtsInitialized = true;
    }
  }

  void _pickRandomStepsForImages() {
    final random = Random();
    int numImages = 2 + random.nextInt(2); // 2 or 3 images
    numImages = numImages.clamp(0, 5);
    Set<int> selectedSteps = {};
    while (selectedSteps.length < numImages) {
      selectedSteps.add(random.nextInt(5));
    }
    _stepsWithImages = selectedSteps.toList();
  }

  void _initTts() async {
    final locale = Localizations.localeOf(context);
    String ttsLang = "en-US";
    if (locale.languageCode == 'gu') {
      ttsLang = "gu-IN";
    } else if (locale.languageCode == 'hi') {
      ttsLang = "hi-IN";
    }
    await flutterTts.setLanguage(ttsLang);
    await flutterTts.setSpeechRate(0.5); // Adjust speed
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _speakCurrentStep() async {
    if (_isPlaying) {
      await flutterTts.speak(_steps[_currentStep]);
    } else {
      await flutterTts.stop();
    }
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      flutterTts.stop();
      if (_isPlaying) {
        _speakCurrentStep();
      }
    } else {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cookingComplete)),
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      flutterTts.stop();
      if (_isPlaying) {
        _speakCurrentStep();
      }
    }
  }

  void _togglePlay() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _speakCurrentStep();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isPlaying ? l10n.cookingTimerStarted : l10n.timerPaused)),
    );
  }

  void _showIngredientsBottomSheet() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.ingredientsRequired, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildIngredientItem(l10n.paneer, '200 ${l10n.g}'),
              _buildIngredientItem(l10n.butter, '2 ${l10n.tbsp}'),
              _buildIngredientItem(l10n.onion, '1 ${l10n.large}'),
              _buildIngredientItem(l10n.tomatoPuree, '1 ${l10n.cup}'),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse('https://www.swiggy.com/instamart');
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.couldNotLaunchInstamart)));
                      }
                    }
                  },
                  icon: const Icon(Icons.shopping_bag),
                  label: Text(l10n.buyNowInstamart),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.orange, // Instamart-like color
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIngredientItem(String name, String quantity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 16)),
          Text(quantity, style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe != null ? '${l10n.cooking} ${widget.recipe!.title}' : l10n.cookingMode),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _showIngredientsBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.step} ${_currentStep + 1} of ${_steps.length}',
                    style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: _buildStepContent(_currentStep),
                  ),
                  const SizedBox(height: 40),
                  
                  // Voice Assistant Status
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.mic, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n.listeningForNextStep, style: const TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Ad Placeholder Section
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.advertisement, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                        const SizedBox(height: 8),
                        const Icon(Icons.ad_units, color: Colors.black45, size: 32),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Fixed Bottom Navigation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _currentStep > 0 ? _prevStep : null,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.arrow_back),
                ),
                ElevatedButton(
                  onPressed: _togglePlay,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(24),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
                ),
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(int stepIndex) {
    String stepText = _steps[stepIndex];
    
    if (_stepsWithImages.contains(stepIndex)) {
      // Split text roughly in half at the nearest period
      int splitIndex = stepText.indexOf('. ', stepText.length ~/ 3);
      if (splitIndex == -1) splitIndex = stepText.length ~/ 2;
      else splitIndex += 1; // Include the period in the first part

      String part1 = stepText.substring(0, splitIndex).trim();
      String part2 = stepText.substring(splitIndex).trim();
      
      String randomImg = _dishImages[stepIndex % _dishImages.length];

      return Column(
        key: ValueKey<int>(stepIndex),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(part1, style: const TextStyle(fontSize: 20, height: 1.5), textAlign: TextAlign.justify),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: randomImg,
              height: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(height: 250, color: Colors.grey[800]),
              errorWidget: (context, url, error) => Container(height: 250, color: Colors.grey[800], child: const Icon(Icons.error)),
            ),
          ),
          const SizedBox(height: 20),
          Text(part2, style: const TextStyle(fontSize: 20, height: 1.5), textAlign: TextAlign.justify),
        ],
      );
    } else {
      return Text(
        stepText,
        key: ValueKey<int>(stepIndex),
        style: const TextStyle(fontSize: 20, height: 1.5),
        textAlign: TextAlign.justify,
      );
    }
  }
}
