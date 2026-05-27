import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:whats_for_dinner/core/config/api_config.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';

final randomLoadingProvider = StateProvider<bool>((ref) => false);

class RandomNotifier extends StateNotifier<List<Recipe>> {
  RandomNotifier(this.ref) : super(const []) {
    ref.listen<List<Ingredient>>(storageProvider, (previous, next) {
      _recalculateMissingIngredients(next);
    });

    Future.microtask(randomRecipes);
  }

  final Ref ref;

  void _recalculateMissingIngredients(List<Ingredient> availableIngredients) {
    state = [
      for (final recipe in state)
        Recipe(
          id: recipe.id,
          title: recipe.title,
          picture: recipe.picture,
          ingredientsList: recipe.ingredientsList,
          unitList: recipe.unitList,
          instructions: recipe.instructions,
          area: recipe.area,
          category: recipe.category,
          tags: recipe.tags,
          youtube: recipe.youtube,
          missingIngredients: _countMissingIngredients(
            recipe.ingredientsList,
            availableIngredients,
          ),
        ),
    ];
  }

  int _countMissingIngredients(
    List<String> recipeIngredients,
    List<Ingredient> availableIngredients,
  ) {
    return recipeIngredients
        .where(
          (recIng) => !availableIngredients.any(
            (pantryIng) =>
                recIng.trim().toLowerCase() ==
                pantryIng.name.trim().toLowerCase(),
          ),
        )
        .length;
  }

  Future<List<Recipe>> _loadRandomMeals(
    List<Ingredient> availableIngredients,
  ) async {
    try {
      final url = ApiConfig.mealDb('randomselection.php');
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) {
        return [];
      }
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> meals = data['meals'] ?? [];
      final List<Recipe> recipesList = [];
      for (final meal in meals) {
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

        final newRecipe = Recipe(
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
          missingIngredients: _countMissingIngredients(
            ingrList,
            availableIngredients,
          ),
        );
        recipesList.add(newRecipe);
      }

      return recipesList;
    } catch (e) {
      dev.log("Errore random recipe: $e");
      return [];
    }
  }

  Future<void> randomRecipes() async {
    ref.read(randomLoadingProvider.notifier).state = true;
    final availableIngredients = ref.read(storageProvider);
    try {
      final List<Recipe> meals = await _loadRandomMeals(availableIngredients);
      state = meals;
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
