import 'package:flutter/material.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';

class WhatCanYouCook extends StatelessWidget {
  const WhatCanYouCook({
    super.key,
    required this.totalIngredients,
    required this.suggestedRecipesCount,
  });
  final List<Ingredient> totalIngredients;
  final int suggestedRecipesCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: SizedBox(
            width: 100,
            child: Image.asset(
              'lib/assets/images/pasta.png',
              fit: BoxFit.contain,
              alignment: Alignment.centerRight,
            ),
          ),
        ),
        Positioned(
          left: 15,
          top: 0,
          bottom: 0,
          right: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'What can you cook today?',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Image.asset(
                      'lib/assets/images/ingredients.png',
                      color: Theme.of(context).colorScheme.onPrimary,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'You have',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(fontSize: 10),
                      ),
                      Text(
                        '${totalIngredients.length}${totalIngredients.length == 1 ? ' ingredient' : ' ingredients'}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Image.asset(
                      'lib/assets/images/fork.png',
                      color: Theme.of(context).colorScheme.onPrimary,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'You can make',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(fontSize: 10),
                      ),
                      Text(
                        '$suggestedRecipesCount${suggestedRecipesCount == 1 ? ' recipe' : ' recipes'}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
