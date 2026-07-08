import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/locale_provider.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Language')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select your preferred language',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildLanguageOption(context, 'English'),
            const SizedBox(height: 16),
            _buildLanguageOption(context, 'Gujarati (ગુજરાતી)'),
            const SizedBox(height: 16),
            _buildLanguageOption(context, 'Hindi (हिंदी)'),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    bool isSelected = _selectedLanguage == language;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedLanguage = language;
        });
        
        String langCode = 'en';
        if (language.contains('Gujarati')) langCode = 'gu';
        if (language.contains('Hindi')) langCode = 'hi';
        
        ref.read(localeProvider.notifier).setLocale(Locale(langCode));
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
        side: BorderSide(
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(
        language,
        style: TextStyle(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
