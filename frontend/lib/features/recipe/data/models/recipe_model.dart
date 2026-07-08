class RecipeModel {
  final int id;
  final String title;
  final String? description;
  final String? imageUrl;
  final int cookingTime;
  final String difficulty;
  final int servingSize;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final bool isPremium;

  RecipeModel({
    required this.id,
    required this.title,
    this.description,
    this.imageUrl,
    this.cookingTime = 0,
    this.difficulty = 'Medium',
    this.servingSize = 1,
    this.calories = 0.0,
    this.protein = 0.0,
    this.fat = 0.0,
    this.carbs = 0.0,
    this.isPremium = false,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      cookingTime: json['cooking_time'] as int? ?? 0,
      difficulty: json['difficulty'] as String? ?? 'Medium',
      servingSize: json['serving_size'] as int? ?? 1,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      isPremium: json['is_premium'] as bool? ?? false,
    );
  }
}
