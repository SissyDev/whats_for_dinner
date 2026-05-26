import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/data/shopping_list.dart';

class ShoppingListNotifier extends StateNotifier<List<ShoppingList>> {
  ShoppingListNotifier() : super(const []);
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingList>>((ref) {
      return ShoppingListNotifier();
    });
