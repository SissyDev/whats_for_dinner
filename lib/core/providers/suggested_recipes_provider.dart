import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/config/api_config.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:whats_for_dinner/core/providers/recipes_provider.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as dev;

final suggRecipesLoadingProvider = StateProvider<bool>((ref) => false);
final randomRecipesLoadingProvider = StateProvider<bool>((ref) => false);

class SuggestionsNotifier extends StateNotifier<List<Recipe>> {
  SuggestionsNotifier(this.ref) : super(const []);
  final Ref ref;
  int _requestSerial = 0;

  String _mealDbIngredientQuery(String ingredientName) {
    return ingredientName.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
  }

  Future<void> suggestedRecipes() async {
    final requestSerial = ++_requestSerial;
    ref.read(suggRecipesLoadingProvider.notifier).state = true;
    try {
      final ingredients = ref.read(storageProvider);
      if (ingredients.isEmpty) {
        state = [];
        ref.read(recipesListProvider.notifier).state = [];
        return;
      }

      final responses = await Future.wait(
        ingredients.map((ingredient) {
          final url = ApiConfig.mealDb(
            'filter.php',
            {'i': _mealDbIngredientQuery(ingredient.name)},
          );
          return http.get(url);
        }),
      );
      if (requestSerial != _requestSerial) return;
      final Set<String> seenIds = {};
      final List<Recipe> allRecipes = [];
      for (final response in responses) {
        if (response.statusCode != 200) continue;
        final data = json.decode(response.body);
        final List meals = data['meals'] ?? [];

        for (final meal in meals) {
          final id = meal['idMeal']?.toString() ?? "";
          if (id.isEmpty || seenIds.contains(id)) continue;
          seenIds.add(id);
          allRecipes.add(
            Recipe(
              id: id,
              title: meal['strMeal'] ?? "",
              picture: meal['strMealThumb'] ?? "",
              ingredientsList: [],
              unitList: [],
              instructions: "",
              area: "",
              category: "",
              tags: "",
              youtube: "",
              missingIngredients: 0,
            ),
          );
        }
      }
      final updatedRecipes = await Future.wait(
        allRecipes.map((recipe) async {
          if (requestSerial != _requestSerial) return recipe;
          final fullRecipe = await ref
              .read(recipesListProvider.notifier)
              .getRecipe(recipe.id);
          return fullRecipe ?? recipe;
        }),
      );
      if (requestSerial != _requestSerial) return;
      state = updatedRecipes;
    } catch (e) {
      dev.log("Errore: $e");
    } finally {
      if (requestSerial == _requestSerial) {
        ref.read(suggRecipesLoadingProvider.notifier).state = false;
      }
    }
  }
}

final suggestedRecipesProvider =
    StateNotifierProvider<SuggestionsNotifier, List<Recipe>>((ref) {
      return SuggestionsNotifier(ref);
    });
