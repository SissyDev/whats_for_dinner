import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:whats_for_dinner/core/config/api_config.dart';
import 'package:whats_for_dinner/core/providers/recipes_provider.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';

final randomLoadingProvider = StateProvider<bool>((ref) => false);

class RandomNotifier extends StateNotifier<List<Recipe>> {
  RandomNotifier(this.ref) : super(const []) {
    Future.microtask(randomRecipes);
  }
  final Ref ref;

  Recipe _recipeFromMeal(Map<String, dynamic> meal, List availableIngredients) {
    final List<String> ingrList = [];
    final List<String> unitList = [];
    for (var i = 1; i <= 20; i++) {
      final String? ingredient = meal['strIngredient$i'];
      final String? unit = meal['strMeasure$i'];
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingrList.add(ingredient.trim());
        unitList.add(unit?.trim() ?? '');
      }
    }

    final missingIngredients = ingrList
        .where(
          (recIng) => !availableIngredients.any(
            (pantryIng) =>
                recIng.trim().toLowerCase() ==
                pantryIng.name.trim().toLowerCase(),
          ),
        )
        .length;

    return Recipe(
      id: meal['idMeal']?.toString() ?? "",
      title: meal['strMeal']?.toString() ?? "",
      picture: meal['strMealThumb']?.toString() ?? "",
      ingredientsList: ingrList,
      unitList: unitList,
      instructions: meal['strInstructions']?.toString() ?? "",
      area: meal['strArea']?.toString() ?? "",
      category: meal['strCategory']?.toString() ?? "",
      tags: meal['strTags']?.toString() ?? "",
      youtube: meal['strYoutube']?.toString() ?? "",
      missingIngredients: missingIngredients,
    );
  }

  Future<List<dynamic>> _loadRandomMeals() async {
    final responses = await Future.wait(
      List.generate(10, (_) {
        final url = ApiConfig.publicMealDb('random.php');
        return http
            .get(url)
            .timeout(const Duration(seconds: 8))
            .then<http.Response?>((response) => response)
            .catchError((e) {
          dev.log("Errore random recipe: $e");
          return null;
        });
      }),
    );

    final Map<String, dynamic> uniqueMeals = {};
    for (final response in responses) {
      try {
        if (response == null) continue;
        if (response.statusCode != 200) continue;
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> meals = data['meals'] ?? [];
        if (meals.isEmpty) continue;
        final meal = meals.first;
        final id = meal['idMeal']?.toString() ?? '';
        if (id.isNotEmpty) uniqueMeals[id] = meal;
      } catch (e) {
        dev.log("Errore random recipe: $e");
      }
    }

    return uniqueMeals.values.toList();
  }

  Future<void> randomRecipes() async {
    ref.read(randomLoadingProvider.notifier).state = true;
      final availableIngredients = ref.read(storageProvider);
      try {
        final meals = await _loadRandomMeals();
        final recipes = meals
            .map((meal) => Map<String, dynamic>.from(meal as Map))
            .map((meal) => _recipeFromMeal(meal, availableIngredients))
            .where((recipe) => recipe.id.isNotEmpty)
            .toList();

      state = recipes;
      final recipesNotifier = ref.read(recipesListProvider.notifier);
      final uniqueRecipes = {
        for (final recipe in recipesNotifier.state) recipe.id: recipe,
        for (final recipe in recipes) recipe.id: recipe,
      };
      recipesNotifier.state = uniqueRecipes.values.toList();
    } catch (e) {
      dev.log("Errore: $e");
    } finally {
      ref.read(randomLoadingProvider.notifier).state = false;
    }
  }
}

final randomRecipesProvider =
    StateNotifierProvider<RandomNotifier, List<Recipe>>((ref) {
      return RandomNotifier(ref);
    });
