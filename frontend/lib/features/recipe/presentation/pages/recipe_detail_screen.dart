import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/recipe_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/favorites_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final RecipeModel? recipe;
  
  const RecipeDetailScreen({super.key, this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final title = recipe?.title ?? l10n.recipeDetails;
    final imageUrl = recipe?.imageUrl ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800&q=80';
    final cookingTime = recipe?.cookingTime ?? 30;
    final calories = recipe?.calories ?? 450;
    final servingSize = recipe?.servingSize ?? 2;
    final protein = recipe?.protein ?? 18;
    final carbs = recipe?.carbs ?? 20;
    final fat = recipe?.fat ?? 22;
    
    // Default ID if recipe ID is not available for favorites
    final recipeId = recipe?.id?.toString() ?? title.toLowerCase().replaceAll(' ', '_');
    final isFavorite = ref.watch(favoritesProvider).contains(recipeId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16, right: 80),
              title: Text(
                title, 
                style: const TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[800],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      child: const Center(child: Icon(Icons.fastfood, size: 100, color: Colors.white)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.9),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null), 
                onPressed: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(recipeId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(!isFavorite ? '$title ${l10n.addedToFavorites}' : '$title ${l10n.removedFromFavorites}')),
                  );
                }
              ),
              IconButton(
                icon: const Icon(Icons.share), 
                onPressed: () {
                  Share.share('${l10n.recipeDetails}: $title\n${l10n.cookingTime}: $cookingTime ${l10n.min}\n${l10n.calories}: $calories ${l10n.calories}');
                }
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoBadge(context, Icons.timer, '$cookingTime ${l10n.min}'),
                      _buildInfoBadge(context, Icons.local_fire_department, '$calories ${l10n.calories}'),
                      _buildInfoBadge(context, Icons.people, '$servingSize ${l10n.servings}'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.ingredients, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  // Currently static ingredients, can be made dynamic later when backend supports it
                  _buildIngredientItem('Paneer', '200g'),
                  _buildIngredientItem('Butter', '2 tbsp'),
                  _buildIngredientItem('Onion', '1 large'),
                  _buildIngredientItem('Tomato Puree', '1 cup'),
                  const SizedBox(height: 24),
                  Text(l10n.nutrition, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('${l10n.protein}: ${protein}g'),
                      Text('${l10n.carbs}: ${carbs}g'),
                      Text('${l10n.fat}: ${fat}g'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.push('/cooking_step', extra: recipe);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(l10n.startCooking),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
        ],
      ),
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
}
