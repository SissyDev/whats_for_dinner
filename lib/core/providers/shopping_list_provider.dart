import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';

class ShoppingListNotifier extends StateNotifier<List<Ingredient>> {
  ShoppingListNotifier() : super(const []);

  List<Ingredient> addToShoppingList(Ingredient ingredient) {
    final List<Ingredient> shoppingList = [];
    if (state.contains(ingredient)) {
      int updatedQty = int.parse(ingredient.quantity);
      updatedQty = updatedQty++;
      state = shoppingList;
      return shoppingList;
    } else {
      shoppingList.add(ingredient);
      state = shoppingList;
      return shoppingList;
    }
  }

  List<Ingredient> removeFromShoppingList(Ingredient ingredient, List<Ingredient> shoppingList) {
    final List<Ingredient> groceries = shoppingList;
    if (state.contains(ingredient)) {
      int updatedQty = int.parse(ingredient.quantity);
      updatedQty = updatedQty--;
      if (updatedQty <= 0) {
        groceries.remove(ingredient);
      }
      state = groceries;
      return groceries;
    } else {
      groceries.remove(ingredient);
      state = groceries;
      return groceries;
    }
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<Ingredient>>((ref) {
      return ShoppingListNotifier();
    });
