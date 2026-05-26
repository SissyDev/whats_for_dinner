import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';
import 'package:whats_for_dinner/core/widgets/places_buttons.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'dart:developer' as dev;

class NewIngredient extends ConsumerStatefulWidget {
  const NewIngredient({super.key});

  @override
  ConsumerState<NewIngredient> createState() => _NewIngredientState();
}

class _NewIngredientState extends ConsumerState<NewIngredient> {
  List<Ingredient> _totalIngredients = [];
  final _searchBarController = TextEditingController();
  final List<Ingredient> _temporaryList = [];
  Color cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadAllIngredients();
  }

  void _loadAllIngredients() async {
    try {
      final result = await ref.read(dbListProvider.notifier).loadIngredients();
      _totalIngredients = result;
    } catch (e, st) {
      dev.log("$e, $st");
    }
    setState(() {});
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIngredients = ref.watch(storageProvider);
    final List<Ingredient> _filteredIngredients = _totalIngredients.where((
      ingredient,
    ) {
      return ingredient.name.toLowerCase().contains(
        _searchBarController.text.toLowerCase(),
      );
    }).toList();
    // Ordering the list
    _filteredIngredients.sort((a, b) {
      final query = _searchBarController.text.toLowerCase();
      final aLower = a.name.toLowerCase();
      final bLower = b.name.toLowerCase();
      bool aStarts = aLower.startsWith(query);
      bool bStarts = bLower.startsWith(query);
      if (aStarts && !bStarts) return -1;
      if (!aStarts && bStarts) return 1;
      return aLower.compareTo(bLower);
    });

    return Scaffold(
      // --- APPBAR ---
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Items',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              'Select what you have at home',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEARCHBAR ---
            TextField(
              controller: _searchBarController,
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search ingredients...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                suffixIcon: _searchBarController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchBarController.clear();
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color.fromARGB(255, 250, 252, 248),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 5),
            // --- PLACES BUTTONS ---
            PlacesButtons(),
            Padding(
              padding: const EdgeInsets.only(left: 4, top: 16, bottom: 10),
              child: Text(
                'Ingredients',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            // --- SPINNER ---
            _totalIngredients.isEmpty
                ? Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      ),
                    ),
                  )
                :
                  // --- LISTVIEW ---
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredIngredients.length,
                      itemBuilder: (context, index) {
                        bool isSelected =
                            selectedIngredients.any(
                              (i) => i.name == _filteredIngredients[index].name,
                            ) ||
                            _temporaryList.any(
                              (i) => i.name == _filteredIngredients[index].name,
                            );
                        return InkWell(
                          splashColor: Colors.transparent,
                          onTap: () async {
                            final ingredient = _filteredIngredients[index];
                            final bool isAlreadyInStock = selectedIngredients
                                .any((i) => i.name == ingredient.name);
                            if (!isAlreadyInStock && !isSelected) {
                              ingredient.place = selectedPlace;
                              _temporaryList.add(ingredient);
                            } else {
                              _temporaryList.remove(ingredient);
                              await ref
                                  .read(storageProvider.notifier)
                                  .removeData(ingredient, ingredient.id);
                            }
                            if (!mounted) return;
                            setState(() {});
                          },
                          child: Card(
                            color: isSelected
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context).colorScheme.onTertiary,
                            margin: EdgeInsets.only(
                              bottom: 8,
                              left: 2,
                              right: 2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    _filteredIngredients[index].category.emoji,
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 180,
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      _filteredIngredients[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: isSelected
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.onSurfaceVariant
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                          ),
                                    ),
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 20),
                                  !isSelected
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.close,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 20),

            // --- ADD INGREDIENTS BUTTON ---
            Center(
              child: Material(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () async {
                    await ref
                        .read(storageProvider.notifier)
                        .addNewIngredients(_temporaryList);
                    if (!mounted) return;
                    setState(() {});
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  splashColor: const Color.fromARGB(67, 14, 85, 4),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 8),
                        Text(
                          'Add items',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onTertiary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
