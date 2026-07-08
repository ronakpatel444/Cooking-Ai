import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/providers/recipe_provider.dart';
import '../../../recipe/data/models/recipe_model.dart';

class AiResultScreen extends ConsumerWidget {
  final List<String> ingredients;

  const AiResultScreen({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeAsync = ref.watch(recipeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Suggestions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ingredients.isNotEmpty)
              Text(
                'Based on: ${ingredients.join(", ")}',
                style: const TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 8),
            const Text(
              'Here are some recipes just for you!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: recipeAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Center(child: Text('Error loading recipes')),
                data: (allRecipes) {
                  // Basic filtering: check if any recipe title or description contains the ingredient
                  List<RecipeModel> filteredRecipes = allRecipes.where((recipe) {
                    if (ingredients.isEmpty) return true;
                    final textToSearch = '${recipe.title} ${recipe.description}'.toLowerCase();
                    return ingredients.any((ing) => textToSearch.contains(ing.toLowerCase()));
                  }).toList();

                  // Fallback: If no match, show some random recipes
                  if (filteredRecipes.isEmpty) {
                    filteredRecipes = allRecipes.take(4).toList();
                  }

                  return ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: InkWell(
                          onTap: () {
                            context.push('/recipe_detail', extra: recipe);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                child: CachedNetworkImage(
                                  imageUrl: recipe.imageUrl ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey[300],
                                    child: const Center(child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.timer, size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text('${recipe.cookingTime} min', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          const Spacer(),
                                          const Icon(Icons.star, size: 16, color: Colors.amber),
                                          const Text('4.7', style: const TextStyle(fontSize: 12)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
