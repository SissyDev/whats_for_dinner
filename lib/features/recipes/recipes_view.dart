import 'package:flutter/material.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:whats_for_dinner/features/recipes/meal.dart';
import 'package:whats_for_dinner/core/widgets/recipes_card.dart';

class RecipesView extends StatelessWidget {
  const RecipesView({super.key, required this.recipes});
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ready to cook')),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Card(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Meal(
                            value: recipes[index].id,
                            initialRecipe: recipes[index],
                          ),
                        ),
                      ),
                      child: RecipesCard(recipe: recipes[index]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
