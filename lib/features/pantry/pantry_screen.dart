import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/widgets/all_places_buttons.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/widgets/ingredient_card.dart';
import 'package:whats_for_dinner/features/pantry/new_ingredient.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';

class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});
  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  late Future<void> _futureIngredients;

  void _addIngredient() {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: const NewIngredient(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _futureIngredients = ref.read(storageProvider.notifier).loadIngredients();
  }

  @override
  Widget build(BuildContext context) {
    String place = ref.watch(selectedPlaceProvider);
    List<Ingredient> stockList = ref.watch(storageProvider);
    final List<Ingredient> filteredList = place == 'All'
        ? stockList
        : stockList.where((ingredient) => ingredient.place == place).toList();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(  
              children: [
                const SizedBox(height: 15),
                // --- PLACES SELECTORS ---
                AllPlacesButtons(),
                
                const Divider(),
            
                FutureBuilder(
                  future: _futureIngredients,
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: filteredList.isEmpty
                              // --- NO INGREDIENTS ---
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'No ingredients to show',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                  ],
                                )
                              // --- INGREDIENTS LIST ---
                              : ListView.builder(
                                  itemCount: filteredList.length,                                  
                                  itemBuilder: (context, index) => IngredientCard(
                                    key: ValueKey(filteredList[index].id),
                                    ingredient: filteredList[index],
                                  ),
                                ),
                        ),
                ),
              ],
            ),
          ),
        ),
        // --- ADD INGREDIENTS BUTTON ---
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            child: Icon(Icons.add),
            onPressed: () {
              _addIngredient();
            },
          ),
        ),
      ],
    );
  }
}
