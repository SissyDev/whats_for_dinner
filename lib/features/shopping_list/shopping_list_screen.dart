// On long press: pulsanti x - modifica - copia - elimina; apre la modalità di selezione

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/providers/shopping_list_provider.dart';
import 'package:whats_for_dinner/core/widgets/all_set_card.dart';
import 'package:whats_for_dinner/core/widgets/grocery_ingredient.dart';
import 'dart:developer' as dev;

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

  @override
  void initState() {
    ref.read(shoppingListProvider.notifier).loadGroceries();
    super.initState();
  }

  void _itemRemover(int index) {
    setState(() {
      ref.watch(shoppingListProvider).removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Ingredient> groceryList = ref.watch(shoppingListProvider);

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
                isEditing: isEditing,
                total: groceryList.length,
                remaining: selectedGroceries.length,
              ),

              const SizedBox(height: 10),

              Expanded(
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
                      child: GroceryIngredient(
                        ingredient: groceryList[index],
                        editing: isEditing,
                        onSelected: (selected) {
                          setState(() {
                            isSelected = selected;
                            if (isSelected == true) {
                              selectedGroceries.add(groceryList[index]);
                              isEditing = true;
                            } else {
                              selectedGroceries.remove(groceryList[index]);
                            }
                            if (selectedGroceries.isEmpty) {
                              isEditing = false;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
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
                  }
                });
              },
              child: Container(
                margin: EdgeInsets.all(12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  isEditing ? Icons.delete : Icons.add,
                  color: Theme.of(context).colorScheme.onTertiary,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
