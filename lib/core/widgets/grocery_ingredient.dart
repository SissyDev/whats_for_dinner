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
    required this.orderIndex
  });
  final Ingredient ingredient;
  final bool editing;
  final bool boughtPage;
  final int orderIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(boughtItemsProvider);
    ref.watch(shoppingListProvider);

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
                final boughtNotifier = ref.read(boughtItemsProvider.notifier);
                final shoppingNotifier = ref.read(
                  shoppingListProvider.notifier,
                );
                if (!editing) {
                  if (boughtPage) {
                    if (ingredient.selected == 0) {  //false
                      boughtNotifier.updateSelection(
                        ingredient,
                        ingredient.id,
                        1,
                      );
                      await Future.delayed(Durations.medium1);
                      boughtNotifier.removeGroceries(ingredient, ingredient.id);
                      shoppingNotifier.addGrocery(ingredient);
                      shoppingNotifier.updateSelection(
                        ingredient,
                        ingredient.id,
                        0,
                      );
                    } else {
                      boughtNotifier.updateSelection(
                        ingredient,
                        ingredient.id,
                        0,
                      );
                    }
                  } else {
                    if (ingredient.selected == 0) {
                      shoppingNotifier.updateSelection(
                        ingredient,
                        ingredient.id,
                        1,
                      );
                      await Future.delayed(Durations.medium1);

                      boughtNotifier.addGrocery(ingredient);

                      boughtNotifier.updateSelection(
                        ingredient,
                        ingredient.id,
                        0,
                      );
                      shoppingNotifier.removeGroceries(
                        ingredient,
                        ingredient.id,
                      );
                    } else {
                      shoppingNotifier.updateSelection(
                        ingredient,
                        ingredient.id,
                        0,
                      );
                    }
                  }
                } else {
                  if (boughtPage) {
                    boughtNotifier.updateSelection(
                      ingredient,
                      ingredient.id,
                      1,
                    );
                  } else {
                    shoppingNotifier.updateSelection(
                      ingredient,
                      ingredient.id,
                      1,
                    );
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
                  color: ingredient.selected == 1
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
            editing && !boughtPage
                ? ReorderableDragStartListener(
                  index: orderIndex,
                  child: Icon(Icons.drag_handle_rounded))
                : const SizedBox(),
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
            // ---  QUANTITY ---
            Text(
              boughtPage ? '' : ingredient.quantity,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
            // --- PICTURE ---
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
