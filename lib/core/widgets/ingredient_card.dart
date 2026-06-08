import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';
import 'package:whats_for_dinner/core/providers/shopping_list_provider.dart';
import 'package:whats_for_dinner/features/pantry/edit_ingredient.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';

class IngredientCard extends ConsumerWidget {
  final Ingredient ingredient;
  const IngredientCard({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Ingredient> shoppingListIngredients = ref.watch(
      shoppingListProvider,
    );
    bool isInShList = shoppingListIngredients.any(
      (item) => item.id == ingredient.id,
    );

    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(width: 5),
            // --- PICTURE + EDIT ---
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditIngredient(ingredient: ingredient),
                ),
              ),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: ingredient.category.color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(child: Text(ingredient.category.emoji)),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditIngredient(ingredient: ingredient),
                ),
              ),
              // --- EDIT ---
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TITLE ---
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ingredient.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  // --- QTY - UNIT - PLACE ---
                  Text(
                    '${ingredient.quantity.toString()} ${ingredient.unit} · ${ingredient.place}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Spacer(),
            // --- CART BUTTON ---
            IconButton(
                  onPressed: () {
                    if (isInShList) {
                      return;
                    } else {
                      ref
                          .read(shoppingListProvider.notifier)
                          .addGrocery(ingredient);
                    }
                  },
                  icon: !isInShList
                      ? Icon(Icons.shopping_cart_outlined)
                      : Icon(Icons.shopping_cart_rounded),
                ),
            // --- DELETE BUTTON ---
            IconButton(
              onPressed: () {
                ref
                    .read(storageProvider.notifier)
                    .removeData(ingredient, ingredient.id);
              },
              icon: Icon(
                Icons.delete,
                size: 25,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
