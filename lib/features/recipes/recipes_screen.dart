import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';
import 'package:whats_for_dinner/core/providers/recipes_provider.dart';
import 'package:whats_for_dinner/features/recipes/meal.dart';
import 'package:whats_for_dinner/core/widgets/recipes_card.dart';
import 'dart:async';

List<String> orderFilterList = ['A-Z ', 'Ready to cook'];
List<String> typeFilterList = ['Title', 'Ingredient'];

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});
  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  String? suggestion;
  bool? isChecked = false;
  Timer? _debounce;
  String? dropdownValue;
  String? filterDropValue;
  String selectedCategory = '';
  List<Recipe> recipesList = [];
  List<Recipe> filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    ref.read(dbListProvider.notifier).loadIngredients();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(recipesListProvider);
    final bool isLoading = ref.watch(recipesLoadingProvider);
    final List<Ingredient> allIngredients = ref.watch(dbListProvider);

    // categories filter
    List<Recipe> filteredRecipes = List.from(recipesList);
    if (selectedCategory == '' || selectedCategory == 'All') {
      filteredRecipes;
    } else {
      filteredRecipes = filteredRecipes.where((recipe) => recipe.category == selectedCategory)
              .toList();
    }
    // sorting
    if (dropdownValue == 'Ready to cook') {
      filteredRecipes.sort(
        (a, b) => a.missingIngredients.compareTo(b.missingIngredients),
      );
    } else {
      filteredRecipes.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
    }
    final List<Ingredient> sortedIngredients = List.from(allIngredients);
    sortedIngredients.sort((a, b) => a.name.compareTo(b.name));

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- SEARCHBAR ---
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Autocomplete(
                    optionsBuilder: (textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Ingredient>.empty();
                      } else {
                        return sortedIngredients.where(
                          (ingredient) =>
                              ingredient.name.trim().toLowerCase().startsWith(
                                textEditingValue.text.trim().toLowerCase(),
                              ),
                        );
                      }
                    },
                    fieldViewBuilder:
                        (
                          context,
                          textEditingController,
                          focusNode,
                          onFieldSubmitted,
                        ) {
                          return TextField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            controller: textEditingController,
                            focusNode: focusNode,
                            textInputAction: TextInputAction.search,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) {
                              setState(() {
                                if (textEditingController.text == '') {
                                  recipesList.clear();
                                  selectedCategory = 'All';
                                  dropdownValue = orderFilterList[0];
                                }
                              });
                            },
                            onSubmitted: (value) {
                              setState(() {});
                              if (value.trim().length > 2) {
                                ref
                                    .read(recipesListProvider.notifier)
                                    .loadRecipes(value.trim().toLowerCase())
                                    .then((recipes) {
                                      setState(() {
                                        recipesList = recipes;
                                        selectedCategory = 'All';
                                        dropdownValue = orderFilterList[0];
                                      });
                                    });
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Title or Ingredient',
                              hintStyle: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),

                              prefixIcon: Icon(Icons.search),
                              suffixIcon: textEditingController.text != ''
                                  ? InkWell(
                                      onTap: () {
                                        ref
                                            .read(recipesListProvider.notifier)
                                            .clearList();
                                        setState(() {
                                          recipesList = [];
                                          filteredRecipes = [];
                                          selectedCategory = '';
                                          dropdownValue = null;
                                          textEditingController.text = '';
                                        });
                                      },
                                      child: const Icon(Icons.close),
                                    )
                                  : null,
                            ),
                          );
                        },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(12),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: double.infinity,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final ingredient = options.elementAt(index);
                                return ListTile(
                                  title: Text(
                                    ingredient.name,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                  onTap: () => onSelected(ingredient),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (option) {
                      setState(() {});
                      if (option.name.trim().length > 2) {
                        ref
                            .read(recipesListProvider.notifier)
                            .loadRecipes(option.name.trim().toLowerCase())
                            .then((recipes) {
                              setState(() {
                                recipesList = recipes;
                                selectedCategory = 'All';
                                dropdownValue = orderFilterList[0];
                              });
                            });
                      }
                    },
                    displayStringForOption: (option) => option.name,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 8),
            // --- CATEGORIES FILTER ---
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: RecipeCategory.values.length,
                itemBuilder: (context, index) {
                  final category =
                      RecipeCategory.values[index].name[0].toUpperCase() +
                      RecipeCategory.values[index].name.substring(1);
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: FilterChip(
                      selected: selectedCategory == category,
                      label: Text(category),
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            if (category == 'All' || selectedCategory == '') {
                              selectedCategory = 'All';
                              filteredRecipes = recipesList;
                            } else {
                              selectedCategory = category;
                              filteredRecipes = recipesList
                                  .where(
                                    (recipe) => selectedCategory.contains(
                                      recipe.category,
                                    ),
                                  )
                                  .toList();
                            }
                          } else {
                            filteredRecipes = recipesList
                                .where(
                                  (recipe) =>
                                      recipe.category == selectedCategory,
                                )
                                .toList();
                            if (selectedCategory == '') {
                              selectedCategory = 'All';
                              filteredRecipes = recipesList;
                            }
                          }
                        });
                      },
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
            Expanded(
              child: recipesList.isEmpty
                  ? Center(child: const Text('Look for some recipes'))
                  : Column(
                      children: [
                        // --- ORDER BY ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Results (${filteredRecipes.length})',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            DropdownButton(
                              alignment: Alignment.centerRight,
                              hint: Text(
                                'Order by ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              value: dropdownValue,
                              onChanged: (value) {
                                setState(() {
                                  if (value == null) {
                                    return;
                                  }
                                  dropdownValue = value;
                                });
                              },
                              items: orderFilterList.map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        // --- RECIPES LIST ---
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final Recipe recipe = filteredRecipes[index];
                              return Material(
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  child: Skeletonizer(
                                    enabled: isLoading,
                                    child: RecipesCard(recipe: recipe),
                                  ),
                                  onTap: () {
                                    final recipe = filteredRecipes[index];
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Meal(
                                              value: recipe.id,
                                              initialRecipe: recipe,
                                            ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
