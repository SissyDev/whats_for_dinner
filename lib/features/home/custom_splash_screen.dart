import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:whats_for_dinner/features/home/home.dart';
import 'package:whats_for_dinner/core/providers/storage_provider.dart';
import 'package:whats_for_dinner/core/providers/suggested_recipes_provider.dart';
import 'package:whats_for_dinner/core/providers/recipes_provider.dart';

class CustomSplashScreen extends ConsumerStatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  ConsumerState<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends ConsumerState<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Avvia l'inizializzazione non appena il widget viene inserito nell'albero
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final minimumDelay = Future.delayed(const Duration(seconds: 3));

    final loadProviders = Future(() async {
      try {
        await ref.read(storageProvider.notifier).loadIngredients();
        ref.read(runningOutProvider);
        
        await ref.read(suggestedRecipesProvider.notifier).suggestedRecipes();
        // Wait for suggestions loading flag to be false
        bool suggestionsReady = false;
        
        while (!suggestionsReady) {
          suggestionsReady = !ref.read(suggRecipesLoadingProvider);
          
          if (!suggestionsReady) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
        
        // Pre-load all recipe details to avoid FutureBuilder spinners
        final suggestedRecipes = ref.read(suggestedRecipesProvider);
        
        for (final recipe in suggestedRecipes) {
          await ref.read(recipesListProvider.notifier).getRecipe(recipe.id);
        }
        
        debugPrint('--- Tutti i provider sono stati caricati con successo! ---');
      } catch (e, stackTrace) {
        debugPrint('Errore durante il caricamento dei provider: $e');
        debugPrint('Stacktrace: $stackTrace');
      }
    });

    await Future.wait([minimumDelay, loadProviders]);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 171, 232, 245), 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,  
              height: 250, 
              child: Lottie.asset(
                'lib/assets/json/cooking.json',
                repeat: true,
                animate: true,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Preparing the kitchen...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
