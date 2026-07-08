import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_recipe_app/core/network/dio_client.dart';
import 'package:ai_recipe_app/features/recipe/data/models/recipe_model.dart';

final recipeProvider = FutureProvider<List<RecipeModel>>((ref) async {
  final dio = ref.watch(dioProvider);
  try {
    final response = await dio.get('/recipes/');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      return data.map((json) => RecipeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recipes');
    }
  } catch (e) {
    throw Exception('Error fetching recipes: $e');
  }
});
