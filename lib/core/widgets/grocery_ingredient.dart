import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';
import 'package:whats_for_dinner/core/providers/shopping_list_provider.dart';
import 'package:whats_for_dinner/features/pantry/edit_ingredient.dart';

class GroceryIngredient extends ConsumerStatefulWidget {
  const GroceryIngredient({
    super.key,
    required this.ingredient,
    required this.onSelected,
    required this.editing,
    required this.onBought,
  });
  final Ingredient ingredient;
  final void Function(bool) onSelected;
  final bool editing;
  final void Function(List<Ingredient>) onBought;
  @override
  ConsumerState<GroceryIngredient> createState() => _GroceryIngredientState();
}

class _GroceryIngredientState extends ConsumerState<GroceryIngredient> {
  bool isChecked = false;
  List<Ingredient> boughtItems = [];
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
            InkWell(
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
              onTap: () async {
                isChecked = true;
                if (isChecked) {
                  int newQuantity = int.parse(widget.ingredient.quantity);
                  newQuantity++;
                  String formattedQty = newQuantity.toString();
                  ref
                      .read(shoppingListProvider.notifier)
                      .updateGroceries(
                        widget.ingredient,
                        widget.ingredient.id,
                        formattedQty,
                      );
                }
                if (!widget.editing) {
                  boughtItems.add(widget.ingredient);
                  widget.onBought(boughtItems);
                  await Future.delayed(Durations.medium1);
                  ref
                      .read(shoppingListProvider.notifier)
                      .removeGroceries(widget.ingredient, widget.ingredient.id);
                }
                setState(() {});
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
                  color: isChecked
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.tertiaryFixedDim,
                ),
                child: Icon(
                  Icons.check,
                  color: isChecked
                      ? Theme.of(context).colorScheme.onTertiary
                      : Theme.of(context).colorScheme.tertiaryFixedDim,
                  size: 20,
                ),
              ),
            ),
            // --- MOVE ITEM ICON ---
            widget.editing ? Icon(Icons.drag_handle_rounded) : const SizedBox(),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EditIngredient(ingredient: widget.ingredient),
                ),
              ),
              child: SizedBox(
                width: 160,
                child: Text(
                  widget.ingredient.name,
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
              widget.ingredient.quantity,
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
              child: Center(child: Text(widget.ingredient.category.emoji)),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
