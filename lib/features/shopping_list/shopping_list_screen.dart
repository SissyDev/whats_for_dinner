// On long press: pulsanti x - modifica - copia - elimina; apre la modalità di selezione

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';

class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  bool? isChecked = false;

  void _itemRemover(int index) {
    setState(() {
      ref.watch(dbListProvider).removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Ingredient> ingredientsList = ref.watch(dbListProvider);
    bool isLongPressed = false;
    Map<int, bool> checkedItems = {};

    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              const Text('TO BUY'),
              Expanded(
                child: ListView.builder(
                  itemCount: ingredientsList.length,
                  itemBuilder: (context, index) => Dismissible(
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Theme.of(context).colorScheme.error,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Icon(Icons.delete, color: Colors.white,),
                      ),
                    ),
                    key: ValueKey(ingredientsList[index].name),
                    onDismissed: (direction) {
                      _itemRemover(
                        int.parse(ingredientsList[index].toString()),
                      );
                    },
                    child: InkWell(
                      onLongPress: () {
                        setState(() {
                          isLongPressed = true;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              fillColor: WidgetStatePropertyAll(
                                isChecked!
                                    ? const Color.fromARGB(255, 94, 138, 111)
                                    : Colors.white,
                              ),
                              value: checkedItems[index] ?? false,
                              onChanged: (value) {
                                setState(() {
                                  checkedItems[index] = value!;
                                });
                              },
                            ),
                            Text(ingredientsList[index].name, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
                            const Spacer(),
                            Text(ingredientsList[index].quantity.toString()),
                            Text(ingredientsList[index].unit),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(children: [Text('BOUGHT')],),
      ],
    );
  }
}
