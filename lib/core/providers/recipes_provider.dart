import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/config/api_config.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';
import 'dart:developer' as dev;

import 'package:whats_for_dinner/core/providers/storage_provider.dart';

final recipesLoadingProvider = StateProvider<bool>((ref) => false);

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  final Ref ref;
  RecipeNotifier(this.ref) : super(const []);

  Future<List<Recipe>> loadRecipes(String value) async {
    try {
      ref.read(recipesLoadingProvider.notifier).state = true;
      final availableIngredients = ref.read(storageProvider);
      final results = await Future.wait([
        http.get(
          ApiConfig.publicMealDb('search.php', {
            's': value,
          }),
        ),
        http.get(
          ApiConfig.mealDb('filter.php', {
            'i': value,
          }),
        ),
      ]);
      final titleResponse = results[0];
      final ingrResponse = results[1];
      if (titleResponse.statusCode != 200 || ingrResponse.statusCode != 200) {
        return [];
      }
      final Map<String, dynamic> titleData = json.decode(titleResponse.body);
      final Map<String, dynamic> ingrData = json.decode(ingrResponse.body);
      final List<dynamic> titleMeals = titleData['meals'] ?? [];
      final List<dynamic> ingrMeals = ingrData['meals'] ?? [];
      if (titleMeals.isEmpty && ingrMeals.isEmpty) {
        ref.read(recipesLoadingProvider.notifier).state = false;
        state = [];
        return state;
      }

      final Map<String, dynamic> combinedMap = {};
      for (var meal in ingrMeals) {
        combinedMap[meal['idMeal'].toString()] = meal;
      }
      for (var meal in titleMeals) {
        combinedMap[meal['idMeal'].toString()] = meal;
      }

      final List<Future<http.Response>> detailRequests = [];
      final List<String> idsToFetch = [];

      for (var id in combinedMap.keys) {
        final meal = combinedMap[id];
        if (meal['strCategory'] == null) {
          idsToFetch.add(id);
          detailRequests.add(
            http.get(
              ApiConfig.mealDb('lookup.php', {'i': id}),
            ),
          );
        }
      }

      if (detailRequests.isNotEmpty) {
        final detailResponses = await Future.wait(detailRequests);
        for (var i = 0; i < detailResponses.length; i++) {
          final res = detailResponses[i];
          if (res.statusCode == 200) {
            final decoded = json.decode(res.body);
            if (decoded['meals'] != null && decoded['meals'].isNotEmpty) {
              final fullMealDetails = decoded['meals'][0];
              final String currentId = idsToFetch[i];
              combinedMap[currentId] = fullMealDetails;
            }
          }
        }
      }

      List<Recipe> _mealsList = [];

      for (final meal in combinedMap.values) {
        final List<String> _ingrList = [];
        final List<String> _unitList = [];
        for (var i = 1; i <= 20; i++) {
          final String? ingredient = meal['strIngredient$i'];
          final String? unit = meal['strMeasure$i'];
          if (ingredient != null && ingredient.trim().isNotEmpty) {
            _ingrList.add(ingredient.trim());
            _unitList.add(unit?.trim() ?? '');
          }
        }

        final missingIngredients = _ingrList
            .where(
              (recIng) => !availableIngredients.any(
                (pantryIng) =>
                    recIng.trim().toLowerCase() ==
                    pantryIng.name.trim().toLowerCase(),
              ),
            )
            .length;

        final newRecipe = Recipe(
          id: meal['idMeal']?.toString() ?? "",
          title: meal['strMeal']?.toString() ?? "",
          picture: meal['strMealThumb']?.toString() ?? "",
          ingredientsList: _ingrList,
          unitList: _unitList,
          area: meal['strArea']?.toString() ?? "",
          instructions: meal['strInstructions']?.toString() ?? "",
          category: meal['strCategory']?.toString() ?? "",
          tags: meal['strTags']?.toString() ?? "",
          youtube: meal['strYoutube']?.toString() ?? "",
          missingIngredients: missingIngredients,
        );
        _mealsList.add(newRecipe);
      }

      final List<Recipe> primaIlNome = [];
      final List<Recipe> poiIngredienti = [];
      for (var recipe in _mealsList) {
        if (recipe.title.contains(value)) {
          primaIlNome.add(recipe);
        } else {
          poiIngredienti.add(recipe);
        }
      }
      primaIlNome.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
      poiIngredienti.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
      _mealsList = [...primaIlNome, ...poiIngredienti];

      ref.read(recipesLoadingProvider.notifier).state = false;

      final Map<String, Recipe> uniqueRecipes = {};
      for (var r in state) {
        uniqueRecipes[r.id] = r;
      }
      for (var r in _mealsList) {
        uniqueRecipes[r.id] = r;
      }
      state = uniqueRecipes.values.toList();
      return _mealsList;
    } catch (e) {
      dev.log("Errore: $e");
      return [];
    } finally {
      ref.read(recipesLoadingProvider.notifier).state = false;
    }
  }

  void clearList() {
    state = [];
  }

  Future<Recipe?> getRecipe(String value) async {
    final cachedRecipe = state.firstWhereOrNull((r) => r.id == value);
    final availableIngredients = ref.read(storageProvider);

    int countMissingIngredients(List<String> ingredientsList) {
      return ingredientsList
          .where(
            (recIng) => !availableIngredients.any(
              (pantryIng) =>
                  recIng.trim().toLowerCase() ==
                  pantryIng.name.trim().toLowerCase(),
            ),
          )
          .length;
    }

    if (cachedRecipe != null &&
        cachedRecipe.ingredientsList.isNotEmpty &&
        cachedRecipe.instructions.trim().isNotEmpty) {
      cachedRecipe.missingIngredients = countMissingIngredients(
        cachedRecipe.ingredientsList,
      );
      state = [
        for (final recipe in state)
          if (recipe.id == cachedRecipe.id) cachedRecipe else recipe,
      ];
      return cachedRecipe;
    }
    try {
      final Uri url = ApiConfig.mealDb('lookup.php', {'i': value});
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] == null || data['meals'].isEmpty) return null;
        final meal = data['meals'][0];

        final List<String> _ingrList = [];
        final List<String> _unitList = [];
        for (var i = 1; i <= 20; i++) {
          final String? ingredient = meal['strIngredient$i'];
          final String? unit = meal['strMeasure$i'];
          if (ingredient != null && ingredient.trim().isNotEmpty) {
            _ingrList.add(ingredient.trim());
            _unitList.add(unit?.trim() ?? '');
          }
        }
        final missingIngredients = countMissingIngredients(_ingrList);
        final newRecipe = Recipe(
          id: meal['idMeal']?.toString() ?? "",
          title: meal['strMeal']?.toString() ?? "",
          picture: meal['strMealThumb']?.toString() ?? "",
          ingredientsList: _ingrList,
          unitList: _unitList,
          area: meal['strArea']?.toString() ?? "",
          instructions: meal['strInstructions']?.toString() ?? "",
          category: meal['strCategory']?.toString() ?? "",
          tags: meal['strTags']?.toString() ?? "",
          youtube: meal['strYoutube']?.toString() ?? "",
          missingIngredients: missingIngredients,
        );

        state = [
          for (final recipe in state)
            if (recipe.id != newRecipe.id) recipe,
          newRecipe,
        ];
        return newRecipe;
      }
    } catch (e) {
      dev.log("Errore lookup: $e");
      return null;
    }
    return null;
  }
}

final recipesListProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>(
  (ref) {
    return RecipeNotifier(ref);
  },
);
