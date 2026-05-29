import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'package:whats_for_dinner/core/widgets/ingredient_card.dart';
import 'package:whats_for_dinner/features/pantry/edit_ingredient.dart';

class RunningLowView extends ConsumerWidget {
  const RunningLowView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runningOutIngredients = ref.watch(runningOutProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Running Low')),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: runningOutIngredients.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditIngredient(ingredient: runningOutIngredients[index])
                      ),
                    ),
                    child: IngredientCard(ingredient: runningOutIngredients[index]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
