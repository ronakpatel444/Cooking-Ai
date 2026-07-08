import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SmartPantryScreen extends StatefulWidget {
  const SmartPantryScreen({super.key});

  @override
  State<SmartPantryScreen> createState() => _SmartPantryScreenState();
}

class _SmartPantryScreenState extends State<SmartPantryScreen> {
  final TextEditingController _ingredientController = TextEditingController();
  
  // State for ingredients
  final List<Map<String, String>> _pantryItems = [
    {'name': 'Tomato', 'category': 'Vegetables'},
    {'name': 'Onion', 'category': 'Vegetables'},
    {'name': 'Turmeric Powder', 'category': 'Spices'},
    {'name': 'Garam Masala', 'category': 'Spices'},
  ];

  void _addIngredient(String name) {
    if (name.trim().isEmpty) return;
    setState(() {
      _pantryItems.insert(0, {'name': name.trim(), 'category': 'Added'});
    });
    _ingredientController.clear();
  }

  void _deleteIngredient(int index) {
    setState(() {
      _pantryItems.removeAt(index);
    });
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pantry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // Open scanner to add items automatically
              context.push('/camera_scan');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What ingredients do you have?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ingredientController,
              onSubmitted: _addIngredient,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'e.g., Tomato, Onion, Chicken...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.add, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check, color: Colors.blue),
                  onPressed: () => _addIngredient(_ingredientController.text),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _pantryItems.isEmpty
                  ? const Center(child: Text('Your pantry is empty. Add some ingredients above!', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      itemCount: _pantryItems.length,
                      itemBuilder: (context, index) {
                        return _buildPantryItem(
                          _pantryItems[index]['name']!, 
                          _pantryItems[index]['category']!,
                          index
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/ai_result');
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Find Recipes with my Pantry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPantryItem(String name, String category, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => _deleteIngredient(index),
        ),
      ),
    );
  }
}
