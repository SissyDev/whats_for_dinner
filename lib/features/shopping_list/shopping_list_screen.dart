// On long press: pulsanti x - modifica - copia - elimina; apre la modalità di selezione

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';
import 'package:whats_for_dinner/core/providers/shopping_list_provider.dart';
import 'package:whats_for_dinner/core/widgets/all_set_card.dart';
import 'package:whats_for_dinner/core/widgets/grocery_ingredient.dart';

List<String> pages = ['TB', 'B'];

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  String selectedPage = pages[0];
  bool isEditing = false;

  void _itemRemover(int index) {
    setState(() {
      ref.watch(shoppingListProvider).removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    //List<Ingredient> ingredientsList = ref.watch(dbListProvider);
    List<Ingredient> groceryList = ref.watch(shoppingListProvider);

    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
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
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontWeight: selectedPage == pages[0]
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25, child: const VerticalDivider()),
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
                                style: Theme.of(context).textTheme.bodyMedium!
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
          AllSetCard(selectedPage: selectedPage, isEditing: isEditing),
          
          const SizedBox(height: 6,),
          Expanded(
            child: ListView.builder(
              itemCount: groceryList.length,
              itemBuilder: (context, index) => Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Theme.of(context).colorScheme.error,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                ),
                key: ValueKey(groceryList[index].name),
                onDismissed: (direction) {
                  _itemRemover(int.parse(groceryList[index].toString()));
                },
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    child: GroceryIngredient(ingredient: groceryList[index]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
