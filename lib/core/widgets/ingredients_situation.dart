import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/widgets/running_out_card.dart';
import 'package:whats_for_dinner/features/pantry/new_ingredient.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'package:whats_for_dinner/core/providers/suggested_recipes_provider.dart';
import 'package:whats_for_dinner/features/recipes/recipes_screen.dart';

class IngredientsSituation extends ConsumerWidget {
  const IngredientsSituation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalIngredients = ref.watch(storageProvider);
    final runningOutIngredients = ref.watch(runningOutProvider);
    final recipesList = ref.watch(suggestedRecipesProvider);
    final isLoading = ref.watch(suggRecipesLoadingProvider);

    return
    // --- NO INGREDIENTS CARD ---
    totalIngredients.isEmpty
        ? Column(
            children: [
              SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: 260,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(64, 162, 174, 148),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 80,
                              width: 120,
                              child: Image.asset(
                                'lib/assets/images/shopping_cart.png',
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Your pantry is empty',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Start by adding ingredients to get recipe suggestions',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NewIngredient(),
                                ),
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Ingredients'),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  Theme.of(
                                    context,
                                  ).buttonTheme.colorScheme!.onSurface,
                                ),
                                foregroundColor: WidgetStatePropertyAll(
                                  Theme.of(
                                    context,
                                  ).buttonTheme.colorScheme!.onSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : // --- RUNNING LOW ---
          Column(
            children: [
              runningOutIngredients.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                'Running low',
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontSize: 14,
                                    ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  ref
                                          .read(selectedPageProvider.notifier)
                                          .state =
                                      1;
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 13,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: SizedBox(
                              width: double.infinity,
                              height: 65,
                              child: ListView.builder(
                                itemCount: runningOutIngredients.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => RunningOutCard(
                                  ingredient: runningOutIngredients[index],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  // --- PANTRY FULL ---
                  : Container(
                      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 12),
                              Text(
                                'Pantry looking good ✅',
                                style: Theme.of(context).textTheme.titleSmall!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                      fontSize: 14,
                                    ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  ref
                                          .read(selectedPageProvider.notifier)
                                          .state =
                                      1;
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 13,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onTertiary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'You\'re stocked up!',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.tertiary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            'No ingredients are running low right now',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.tertiary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              // --- NO RECIPES FOUND ---
              !isLoading && recipesList.isEmpty
                  ? Column(
                      children: [
                        SizedBox(height: 14),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(64, 162, 174, 148),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 260,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 80,
                                        width: 120,
                                        child: Image.asset(
                                          'lib/assets/images/lens.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'No matching recipes found',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                              fontSize: 18,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'We couldn\'t find any recipes with your current ingredients',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RecipesScreen(),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Theme.of(context)
                                                    .buttonTheme
                                                    .colorScheme!
                                                    .onSurface,
                                              ),
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                Theme.of(context)
                                                    .buttonTheme
                                                    .colorScheme!
                                                    .onSecondary,
                                              ),
                                        ),
                                        child: const Text('Browse Recipes'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NewIngredient(),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                Theme.of(context)
                                                    .buttonTheme
                                                    .colorScheme!
                                                    .tertiary,
                                              ),
                                        ),
                                        child: const Text(
                                          'or add more ingredients ',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          );
  }
}
