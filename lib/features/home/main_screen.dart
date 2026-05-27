import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:whats_for_dinner/core/widgets/ingredients_situation.dart';
import 'package:whats_for_dinner/core/widgets/what_can_you_cook.dart';
import 'package:whats_for_dinner/features/recipes/recipes_view.dart';
import 'package:whats_for_dinner/core/widgets/suggested_recipes_card.dart';
import 'package:whats_for_dinner/core/providers/random_recipes_provider.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'package:whats_for_dinner/core/providers/suggested_recipes_provider.dart';
import 'package:whats_for_dinner/features/recipes/meal.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<Recipe> _stableRandomRecipes = const [];
  bool _randomRetryScheduled = false;

  @override
  void initState() {
    super.initState();
    ref.listenManual(randomRecipesProvider, (previous, next) {
      if (next.isNotEmpty) {
        setState(() {
          _stableRandomRecipes = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalIngredients = ref.watch(storageProvider);
    final recipesList = ref.watch(suggestedRecipesProvider);
    final randomRecipes = ref.watch(randomRecipesProvider);
    final isLoading = ref.watch(suggRecipesLoadingProvider);
    final isRandomLoading = ref.watch(randomLoadingProvider);
    final displayedRandomRecipes = _stableRandomRecipes.isEmpty
        ? randomRecipes
        : _stableRandomRecipes;
    if (displayedRandomRecipes.isEmpty &&
        !isRandomLoading &&
        !_randomRetryScheduled) {
      _randomRetryScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(randomRecipesProvider.notifier).randomRecipes().whenComplete(() {
          if (mounted) {
            setState(() {
              _randomRetryScheduled = false;
            });
          }
        });
      });
    }
    final suggestedRecipesCount = totalIngredients.isEmpty
        ? 0
        : recipesList.length;
    // sorting
    final List<Recipe> sortedRecipes = List.from(recipesList);
    sortedRecipes.sort(
      (a, b) => a.missingIngredients.compareTo(b.missingIngredients),
    );
    final List<Recipe> sortedRandomRecipes = List.from(displayedRandomRecipes);
    sortedRandomRecipes.sort(
      (a, b) => a.missingIngredients.compareTo(b.missingIngredients),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- WHAT CAN YOU COOK TODAY ---
          WhatCanYouCook(
            totalIngredients: totalIngredients,
            suggestedRecipesCount: suggestedRecipesCount,
          ),
          // --- RUNNING LOW/NO INGREDIENTS/PANTRY FULL/NO RECIPES ---
          const IngredientsSituation(),
          // --- READY TO COOK ---
          totalIngredients.isNotEmpty && (isLoading || recipesList.isNotEmpty)
              ? Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  child: SizedBox(
                    height: 240,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            Text(
                              'Ready to cook',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontSize: 18,
                                  ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipesView(recipes: sortedRecipes),
                                ),
                              ),
                              child: Text(
                                'View All',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            height: 190,
                            child: isLoading
                                ? Center(
                                    child: Container(
                                      height: 120,
                                      width: 230,
                                      alignment: Alignment.center,
                                      child: const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : totalIngredients.isNotEmpty
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: sortedRecipes.length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        width: 200,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Meal(
                                                  value:
                                                      sortedRecipes[index].id,
                                                  initialRecipe:
                                                      sortedRecipes[index],
                                                ),
                                              ),
                                            );
                                          },
                                          child: SuggestedRecipesCard(
                                            recipe: sortedRecipes[index],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),

          // --- RANDOM RECIPES ---
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              height: 260,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 15),
                      Text(
                        'Get inspired',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipesView(recipes: sortedRandomRecipes),
                          ),
                        ),
                        child: Text(
                          'View All',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                      height: 210,
                      child: isRandomLoading && displayedRandomRecipes.isEmpty
                          ? Center(
                              child: Container(
                                height: 120,
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: sortedRandomRecipes.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 250,
                                  height: 150,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Meal(
                                            value:
                                                sortedRandomRecipes[index].id,
                                            initialRecipe:
                                                sortedRandomRecipes[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: SuggestedRecipesCard(
                                      recipe: sortedRandomRecipes[index],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
