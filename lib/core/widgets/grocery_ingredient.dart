import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';
import 'package:whats_for_dinner/core/providers/bought_items_provider.dart';
import 'package:whats_for_dinner/core/providers/shopping_list_provider.dart';
import 'package:whats_for_dinner/features/pantry/edit_ingredient.dart';

class GroceryIngredient extends ConsumerWidget {
  const GroceryIngredient({
    super.key,
    required this.ingredient,
    required this.editing,
    required this.boughtPage,
  });
  final Ingredient ingredient;
  final bool editing;
  final bool boughtPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boughtItems = ref.watch(boughtItemsProvider);
    final toBuyItems = ref.watch(shoppingListProvider);

    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            // --- CHECKBOX ---
            InkWell(
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              onTap: () async {
                if (!editing) {
                  if (ingredient.selected == 0) {
                    ref
                        .read(shoppingListProvider.notifier)
                        .updateSelection(ingredient, ingredient.id, 1);
                    await Future.delayed(Durations.medium2);
                    ref
                        .read(shoppingListProvider.notifier)
                        .removeGroceries(ingredient, ingredient.id);
                    ref
                        .read(boughtItemsProvider.notifier)
                        .addGrocery(ingredient);
                    ref
                        .read(boughtItemsProvider.notifier)
                        .updateSelection(ingredient, ingredient.id, 0);
                  } else {
                    ref
                        .read(shoppingListProvider.notifier)
                        .updateSelection(ingredient, ingredient.id, 0);
                  }
                } else {
                  if (ingredient.selected == 0) {
                    ref
                        .read(shoppingListProvider.notifier)
                        .updateSelection(ingredient, ingredient.id, 1);
                  } else {
                    ref
                        .read(shoppingListProvider.notifier)
                        .updateSelection(ingredient, ingredient.id, 0);
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.all(8),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.tertiary,
                    width: 2,
                  ),
                  color: ingredient.selected == 1 || (editing && boughtPage)
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.onTertiary,
                ),
                child: Icon(
                  Icons.check,
                  color: ingredient.selected == 1 
                      ? Theme.of(context).colorScheme.onTertiary
                      : Theme.of(context).colorScheme.onTertiary,
                  size: 20,
                ),
              ),
            ),
            // --- MOVE ITEM ICON ---
            editing ? Icon(Icons.drag_handle_rounded) : const SizedBox(),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditIngredient(ingredient: ingredient),
                ),
              ),
              child: SizedBox(
                width: 160,
                child: Text(
                  ingredient.name,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),

            const Spacer(),
            // --- PICTURE ---
            Text(
              ingredient.quantity,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(child: Text(ingredient.category.emoji)),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
