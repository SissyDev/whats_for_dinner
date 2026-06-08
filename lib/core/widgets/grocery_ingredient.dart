import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';
import 'package:whats_for_dinner/core/providers/shopping_list_provider.dart';
import 'package:whats_for_dinner/features/pantry/edit_ingredient.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'package:whats_for_dinner/features/shopping_list/shopping_list_screen.dart';

class GroceryIngredient extends ConsumerStatefulWidget {
  const GroceryIngredient({
    super.key,
    required this.ingredient,
    required this.onSelected,
    required this.editing,
  });
  final Ingredient ingredient;
  final void Function(bool) onSelected;
  final bool editing;
  @override
  ConsumerState<GroceryIngredient> createState() => _GroceryIngredientState();
}

class _GroceryIngredientState extends ConsumerState<GroceryIngredient> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    ref.watch(shoppingListProvider);

    return Card(
      elevation: 5,
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            // --- CHECKBOX ---
            Checkbox(
              checkColor: isChecked
                  ? Theme.of(context).colorScheme.onTertiary
                  : Theme.of(context).colorScheme.tertiary,
              fillColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.tertiary,
              ),
              value: isChecked,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  isChecked = value;
                  widget.onSelected(value);
                });
              },
            ),
            // --- MOVE ITEM ICON ---
            widget.editing ? Icon(Icons.drag_handle_rounded) : const SizedBox(),
            const SizedBox(width: 10),
            // --- PICTURE + EDIT ---
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EditIngredient(ingredient: widget.ingredient),
                ),
              ),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(child: Text(widget.ingredient.category.emoji)),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EditIngredient(ingredient: widget.ingredient),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // --- TITLE ---
                  SizedBox(
                    width: 100,
                    child: Text(
                      widget.ingredient.name,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                // --- QTY ---
                Text(
                  '${widget.ingredient.quantity.toString()} ${widget.ingredient.unit}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                IconButton(
                  onPressed: () {
                    ref
                        .read(shoppingListProvider.notifier)
                        .removeGroceries(
                          widget.ingredient,
                          widget.ingredient.id,
                        );
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 25,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            // --- DELETE BUTTON ---
          ],
        ),
      ),
    );
  }
}
