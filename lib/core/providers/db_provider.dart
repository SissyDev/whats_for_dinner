import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/config/api_config.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_categorizer.dart';
import 'package:http/http.dart' as http;
import 'package:whats_for_dinner/features/home/main_screen.dart';
import 'dart:convert';
import 'package:whats_for_dinner/features/pantry/pantry_screen.dart';
import 'package:whats_for_dinner/features/recipes/recipes_screen.dart';
import 'package:whats_for_dinner/features/shopping_list/shopping_list_screen.dart';
import 'dart:developer' as dev;

final StateProvider<String> selectedPlaceProvider = StateProvider<String>(
  (ref) => 'All',
);

final List<Widget> pages = const [
  MainScreen(),
  PantryScreen(),
  RecipesScreen(),
  ShoppingListScreen(),
];

final List<String> titles = const [
  'What to cook?',
  'Your Ingredients',
  'Browse Recipes',
  'Shopping List',
];

final StateProvider<int> selectedPageProvider = StateProvider<int>((ref) => 0);

class DbNotifier extends StateNotifier<List<Ingredient>> {
  DbNotifier() : super(const []);
  List<Ingredient> allIngredients = [];

  Future<List<Ingredient>> loadIngredients() async {
    if (state.isNotEmpty) return state;
    final url = ApiConfig.publicMealDb('list.php', {
      'i': 'list',
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<dynamic> meals = listData['meals'];
      final List<Ingredient> _ingrList = [];
      for (final meal in meals) {
        if (meal['idIngredient'] == null || meal['strIngredient'] == null) {
          continue;
        }
        final newIngr = Ingredient(
          picture: meal['strThumb'] ?? '',
          id: meal['idIngredient'],
          name: meal['strIngredient'],
          category: categorizeIngredient(type: meal['strType'], name: meal['strIngredient']),
          description: meal['strDescription']
        );
        _ingrList.add(newIngr);
      }
      state = _ingrList;
      return _ingrList;
    } else {
      dev.log('errore');
      throw Exception('Errore caricamento');
    }
  }
}

final dbListProvider = StateNotifierProvider<DbNotifier, List<Ingredient>>((
  ref,
) {
  return DbNotifier();
});
