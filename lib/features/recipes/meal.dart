import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/recipe.dart';
import 'package:whats_for_dinner/core/providers/recipes_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class Meal extends ConsumerStatefulWidget {
  const Meal({super.key, required this.value, this.initialRecipe});
  final String value;
  final Recipe? initialRecipe;
  @override
  ConsumerState<Meal> createState() {
    return _MealState();
  }
}

class _MealState extends ConsumerState<Meal> {
  late Future _recipeFuture;

  @override
  void initState() {
    final initialRecipe = widget.initialRecipe;
    if (initialRecipe != null &&
        initialRecipe.ingredientsList.isNotEmpty &&
        initialRecipe.instructions.trim().isNotEmpty) {
      _recipeFuture = Future.value(initialRecipe);
    } else {
      _recipeFuture = ref.read(recipesListProvider.notifier).getRecipe(
        widget.value,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(recipesListProvider);

    return FutureBuilder(
      future: _recipeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('Impossibile caricare i dettagli'));
        }
        final recipe = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(recipe.title),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AspectRatio(
                  aspectRatio: 10 / 9,
                  child: CachedNetworkImage(
                    imageUrl: recipe.picture,
                    fit: BoxFit.cover,
                    width: double.infinity,

                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 280,
                        decoration: BoxDecoration(color: Colors.transparent),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipe.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                child: Padding(
                                  padding: EdgeInsetsGeometry.all(10),
                                  child: Text(
                                    'Ingredients',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onInverseSurface,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                    left: 10,
                                    right: 10,
                                    bottom: 5,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (
                                        var i = 0;
                                        i <= recipe.ingredientsList.length - 1;
                                        i++
                                      )
                                        Text(
                                          '- ${recipe.unitList[i]} ${recipe.ingredientsList[i]}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                              ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                              Text(
                                'Instructions',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(recipe.instructions),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Theme.of(
                                    context,
                                  ).buttonTheme.colorScheme!.onPrimary,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).buttonTheme.colorScheme!.primary,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  final String urlString = recipe.youtube;
                                  final Uri url = Uri.parse(urlString);
                                  try {
                                    await launchUrl(
                                      url,
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } catch (e) {
                                    debugPrint(
                                      'Errore durante l\'apertura del link: $e',
                                    );
                                    await launchUrl(url);
                                  }
                                },
                                icon: const Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.red,
                                ),
                                label: const Text('Watch on Youtube'),
                              ),
                              const SizedBox(height: 80),
                            ],
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
      },
    );
  }
}
