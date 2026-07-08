import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/recipe/data/models/recipe_model.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/language_selection_screen.dart';
import '../../features/auth/presentation/pages/onboarding_screen.dart';
import '../../features/home/presentation/pages/main_layout_screen.dart';
import '../../features/home/presentation/pages/search_screen.dart';
import '../../features/home/presentation/pages/categories_screen.dart';
import '../../features/ai_chef/presentation/pages/ai_chef_input_screen.dart';
import '../../features/ai_chef/presentation/pages/ai_result_screen.dart';
import '../../features/ai_chef/presentation/pages/text_ingredient_screen.dart';
import '../../features/ai_chef/presentation/pages/voice_search_screen.dart';
import '../../features/ai_chef/presentation/pages/camera_scan_screen.dart';
import '../../features/recipe/presentation/pages/recipe_detail_screen.dart';
import '../../features/recipe/presentation/pages/cooking_step_screen.dart';
import '../../features/user_data/presentation/pages/favorites_screen.dart';
import '../../features/user_data/presentation/pages/smart_pantry_screen.dart';
import '../../features/user_data/presentation/pages/meal_planner_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/settings_screen.dart';
import '../../features/profile/presentation/pages/premium_screen.dart';
import '../../features/profile/presentation/pages/notifications_screen.dart';
import '../../features/profile/presentation/pages/community_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainLayoutScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/ai_chef',
        name: 'ai_chef',
        builder: (context, state) => const AiChefInputScreen(),
      ),
      GoRoute(
        path: '/ai_result',
        name: 'ai_result',
        builder: (context, state) {
          final ingredients = state.extra as List<String>? ?? [];
          return AiResultScreen(ingredients: ingredients);
        },
      ),
      GoRoute(
        path: '/text_ingredient',
        name: 'text_ingredient',
        builder: (context, state) => const TextIngredientScreen(),
      ),
      GoRoute(
        path: '/voice_search',
        name: 'voice_search',
        builder: (context, state) => const VoiceSearchScreen(),
      ),
      GoRoute(
        path: '/camera_scan',
        name: 'camera_scan',
        builder: (context, state) => const CameraScanScreen(),
      ),
      GoRoute(
        path: '/recipe_detail',
        name: 'recipe_detail',
        builder: (context, state) {
          final recipe = state.extra as RecipeModel?;
          return RecipeDetailScreen(recipe: recipe);
        },
      ),
      GoRoute(
        path: '/cooking_step',
        name: 'cooking_step',
        builder: (context, state) {
          final recipe = state.extra as RecipeModel?;
          return CookingStepScreen(recipe: recipe);
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/smart_pantry',
        name: 'smart_pantry',
        builder: (context, state) => const SmartPantryScreen(),
      ),
      GoRoute(
        path: '/meal_planner',
        name: 'meal_planner',
        builder: (context, state) => const MealPlannerScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/premium',
        name: 'premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/community',
        name: 'community',
        builder: (context, state) => const CommunityScreen(),
      ),
    ],
  );
});
