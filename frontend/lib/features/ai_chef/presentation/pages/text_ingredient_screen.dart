import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TextIngredientScreen extends StatefulWidget {
  const TextIngredientScreen({super.key});

  @override
  State<TextIngredientScreen> createState() => _TextIngredientScreenState();
}

class _TextIngredientScreenState extends State<TextIngredientScreen> {
  final List<String> _commonIngredients = [
    'Tomato', 'Onion', 'Potato', 'Garlic', 'Ginger',
    'Chili', 'Paneer', 'Chicken', 'Eggs', 'Milk', 'Rice', 'Wheat Flour'
  ];
  
  final List<String> _selectedIngredients = [];
  final TextEditingController _customIngredientController = TextEditingController();

  void _toggleIngredient(String item) {
    setState(() {
      if (_selectedIngredients.contains(item)) {
        _selectedIngredients.remove(item);
      } else {
        _selectedIngredients.add(item);
      }
    });
  }

  void _addCustomIngredient() {
    final text = _customIngredientController.text.trim();
    if (text.isNotEmpty && !_selectedIngredients.contains(text)) {
      setState(() {
        _selectedIngredients.add(text);
        if (!_commonIngredients.contains(text)) {
          _commonIngredients.insert(0, text); // Add to top of list
        }
      });
      _customIngredientController.clear();
    }
  }

  @override
  void dispose() {
    _customIngredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Describe Ingredients'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customIngredientController,
                    decoration: InputDecoration(
                      hintText: 'Type an ingredient (e.g. Cabbage)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onSubmitted: (_) => _addCustomIngredient(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCustomIngredient,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _commonIngredients.length,
              itemBuilder: (context, index) {
                final item = _commonIngredients[index];
                final isSelected = _selectedIngredients.contains(item);
                return CheckboxListTile(
                  title: Text(item),
                  value: isSelected,
                  onChanged: (bool? value) {
                    _toggleIngredient(item);
                  },
                  activeColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _selectedIngredients.isEmpty
                ? null
                : () {
                    context.push('/ai_result');
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Find Recipes (${_selectedIngredients.length})'),
          ),
        ),
      ),
    );
  }
}
