import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/animations/shake_widget.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/providers/shopping_list_provider.dart';
import 'package:whats_for_dinner/core/widgets/all_set_card.dart';
import 'package:whats_for_dinner/core/widgets/grocery_ingredient.dart';
import 'package:whats_for_dinner/features/shopping_list/new_grocery.dart';

List<String> pages = ['TB', 'B'];

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  String selectedPage = pages[0];
  bool isEditing = false;
  bool isSelected = false;
  List<Ingredient> selectedGroceries = [];
  List<Ingredient> boughtIngredients = [];

  @override
  void initState() {
    ref.read(shoppingListProvider.notifier).loadGroceries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Ingredient> groceryList = ref.watch(shoppingListProvider);

    void _openModalBottomSheet() async {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => NewGrocery()));
      if (mounted) {
        setState(() {});
        ref.read(shoppingListProvider.notifier).loadGroceries();
      }
    }

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Stack(
        children: [
          Column(
            children: [
              // --- TO BUY - BOUGHT ROW ---
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onTertiary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPage = pages[0];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: BoxBorder.fromLTRB(
                                    top: BorderSide.none,
                                    right: BorderSide.none,
                                    bottom: selectedPage == pages[0]
                                        ? BorderSide(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                            width: 2,
                                          )
                                        : BorderSide.none,
                                    left: BorderSide.none,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 40,
                                  ),
                                  child: Text(
                                    'TO BUY',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: selectedPage == pages[0]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              child: const VerticalDivider(),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPage = pages[1];
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: BoxBorder.fromLTRB(
                                    top: BorderSide.none,
                                    right: BorderSide.none,
                                    bottom: selectedPage == pages[1]
                                        ? BorderSide(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                            width: 2,
                                          )
                                        : BorderSide.none,
                                    left: BorderSide.none,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 40,
                                  ),
                                  child: Text(
                                    'BOUGHT',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: selectedPage == pages[1]
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // --- ALL SET / GOOD JOB CARDS ---
              AllSetCard(
                selectedPage: selectedPage,
                onEdit: (editing) {
                  setState(() {
                    isEditing = editing;
                  });
                },
                total: groceryList.length,
                remaining: selectedGroceries.length,
                bought: boughtIngredients.length,
              ),

              const SizedBox(height: 10),
              // -- - GROCERIES LIST ---
              selectedPage == 'TB'
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: groceryList.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                              left: 12,
                              right: 12,
                            ),
                            child: ShakeWidget(
                              shake: isEditing,
                              child: GroceryIngredient(
                                ingredient: groceryList[index],
                                editing: isEditing,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      if (!selectedGroceries.any(
                                        (element) =>
                                            element.id == groceryList[index].id,
                                      )) {
                                        selectedGroceries.add(
                                          groceryList[index],
                                        );
                                      }
                                      isEditing = true;
                                    } else {
                                      selectedGroceries.removeWhere(
                                        (element) =>
                                            element.id == groceryList[index].id,
                                      );
                                    }
                                  });
                                },
                                onBought: (boughtItems) {
                                  boughtIngredients = boughtItems;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: boughtIngredients.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 4,
                              left: 12,
                              right: 12,
                            ),
                            child: ShakeWidget(
                              shake: isEditing,
                              child: GroceryIngredient(
                                ingredient: boughtIngredients[index],
                                editing: isEditing,
                                onSelected: (selected) {
                                  if (isEditing) {
                                    if (selected) {
                                      if (!selectedGroceries.any(
                                        (element) =>
                                            element.id ==
                                            boughtIngredients[index].id,
                                      )) {
                                        selectedGroceries.add(
                                          boughtIngredients[index],
                                        );
                                      }
                                    } else {
                                      selectedGroceries.removeWhere(
                                        (element) =>
                                            element.id == groceryList[index].id,
                                      );
                                    }
                                  }
                                  setState(() {});
                                },
                                onBought: (boughtItems) {
                                  boughtIngredients = boughtItems;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          // --- ADD GROCERY BUTTON ---
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isEditing) {
                    for (final item in selectedGroceries) {
                      ref
                          .read(shoppingListProvider.notifier)
                          .removeGroceries(item, item.id);
                    }
                    isEditing = false;
                    selectedGroceries = [];
                  } else {
                    _openModalBottomSheet();
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  isEditing ? Icons.delete : Icons.add,
                  color: Theme.of(context).colorScheme.onTertiary,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
