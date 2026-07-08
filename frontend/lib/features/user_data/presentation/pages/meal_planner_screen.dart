import 'package:flutter/material.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  int _selectedDayIndex = 3; // Default to today (index 3 for Wed, assuming week starts Sun/Mon)

  final List<String> _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<int> _dates = [9, 10, 11, 12, 13, 14, 15];

  // Dummy data map representing meals for different days
  final Map<int, List<Map<String, dynamic>>> _mealsData = {
    2: [
      {'type': 'Breakfast', 'recipe': 'Oats & Fruits', 'time': '8:30 AM', 'isEmpty': false},
      {'type': 'Lunch', 'recipe': 'Healthy Salad', 'time': '1:30 PM', 'isEmpty': false},
      {'type': 'Dinner', 'recipe': 'Add Recipe', 'time': '8:00 PM', 'isEmpty': true},
    ],
    3: [
      {'type': 'Breakfast', 'recipe': 'Poha', 'time': '8:00 AM', 'isEmpty': false},
      {'type': 'Lunch', 'recipe': 'Add Recipe', 'time': '1:00 PM', 'isEmpty': true},
      {'type': 'Dinner', 'recipe': 'Paneer Tikka', 'time': '8:30 PM', 'isEmpty': false},
    ],
    4: [
      {'type': 'Breakfast', 'recipe': 'Add Recipe', 'time': '8:00 AM', 'isEmpty': true},
      {'type': 'Lunch', 'recipe': 'Dal Rice', 'time': '1:00 PM', 'isEmpty': false},
      {'type': 'Dinner', 'recipe': 'Spicy Noodles', 'time': '9:00 PM', 'isEmpty': false},
    ],
  };

  @override
  Widget build(BuildContext context) {
    // Get meals for selected day, or show empty templates if none exist
    final List<Map<String, dynamic>> dailyMeals = _mealsData[_selectedDayIndex] ?? [
      {'type': 'Breakfast', 'recipe': 'Add Recipe', 'time': '8:00 AM', 'isEmpty': true},
      {'type': 'Lunch', 'recipe': 'Add Recipe', 'time': '1:00 PM', 'isEmpty': true},
      {'type': 'Dinner', 'recipe': 'Add Recipe', 'time': '8:00 PM', 'isEmpty': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_checkout),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Grocery list generated!')));
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Week View
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  bool isSelected = index == _selectedDayIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_days[index], style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('${_dates[index]}', style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: dailyMeals.length,
                itemBuilder: (context, index) {
                  final meal = dailyMeals[index];
                  return _buildMealSlot(meal['type'], meal['recipe'], meal['time'], index, isEmpty: meal['isEmpty']);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Find the first empty meal slot or default to the first one
          int mealIndex = 0;
          String type = 'Meal';
          for (int i = 0; i < dailyMeals.length; i++) {
            if (dailyMeals[i]['isEmpty'] == true) {
              mealIndex = i;
              type = dailyMeals[i]['type'];
              break;
            }
          }
          _showRecipeSelector(context, _selectedDayIndex, mealIndex, type);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMealSlot(String type, String recipe, String time, int mealIndex, {bool isEmpty = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(recipe, style: TextStyle(color: isEmpty ? Colors.grey : Colors.black, fontSize: 16)),
          ],
        ),
        trailing: isEmpty
            ? const Icon(Icons.add_circle_outline)
            : const Icon(Icons.edit, color: Colors.grey),
        onTap: () {
          _showRecipeSelector(context, _selectedDayIndex, mealIndex, type);
        },
      ),
    );
  }

  void _showRecipeSelector(BuildContext context, int dayIndex, int mealIndex, String mealType) {
    final List<String> dummyRecipes = [
      'Paneer Butter Masala',
      'Healthy Salad',
      'Oats & Fruits',
      'Dal Rice',
      'Spicy Noodles',
      'Avocado Toast',
      'Grilled Chicken'
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Recipe for $mealType', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: dummyRecipes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.fastfood),
                      title: Text(dummyRecipes[index]),
                      onTap: () {
                        setState(() {
                          // Initialize day array if it doesn't exist
                          if (!_mealsData.containsKey(dayIndex)) {
                            _mealsData[dayIndex] = [
                              {'type': 'Breakfast', 'recipe': 'Add Recipe', 'time': '8:00 AM', 'isEmpty': true},
                              {'type': 'Lunch', 'recipe': 'Add Recipe', 'time': '1:00 PM', 'isEmpty': true},
                              {'type': 'Dinner', 'recipe': 'Add Recipe', 'time': '8:00 PM', 'isEmpty': true},
                            ];
                          }
                          // Update the specific meal
                          _mealsData[dayIndex]![mealIndex]['recipe'] = dummyRecipes[index];
                          _mealsData[dayIndex]![mealIndex]['isEmpty'] = false;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
