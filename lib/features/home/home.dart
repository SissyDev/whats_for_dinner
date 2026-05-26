import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'package:whats_for_dinner/core/providers/suggested_recipes_provider.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  @override
  ConsumerState<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<Home> {
  Timer? _suggestionsDebounce;
  String _ingredientsSignature = '';

  @override
  void initState() {
    super.initState();
    ref.listenManual(storageProvider, (previous, next) {
      final nextSignature =
          next.map((ingredient) => ingredient.name.toLowerCase()).toList()
            ..sort();
      final signature = nextSignature.join('|');
      if (signature == _ingredientsSignature) return;

      _ingredientsSignature = signature;
      _suggestionsDebounce?.cancel();

      if (next.isEmpty) {
        ref.read(suggRecipesLoadingProvider.notifier).state = false;
        ref.read(suggestedRecipesProvider.notifier).suggestedRecipes();
        return;
      }

      _suggestionsDebounce = Timer(const Duration(milliseconds: 250), () {
        ref.read(suggestedRecipesProvider.notifier).suggestedRecipes();
      });
    });
  }

  @override
  void dispose() {
    _suggestionsDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = ref.watch(selectedPageProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.asset(
            'lib/assets/images/chefHat.png',
            fit: BoxFit.fitHeight,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(
          titles[pageIndex],
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        type: BottomNavigationBarType.fixed,
        onTap: (selectedPage) {
          ref.read(selectedPageProvider.notifier).state = selectedPage;
        },
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: 'Pantry'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining_rounded),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Groceries',
          ),
        ],
      ),
    );
  }
}
