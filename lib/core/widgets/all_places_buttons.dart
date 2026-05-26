import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/providers/db_provider.dart';

class AllPlacesButtons extends ConsumerStatefulWidget {
  const AllPlacesButtons({super.key});
  @override
  ConsumerState<AllPlacesButtons> createState() => _PlacesButtonsState();
}

class _PlacesButtonsState extends ConsumerState<AllPlacesButtons> {
  @override
  Widget build(BuildContext context) {
    final selectedPlace = ref.watch(selectedPlaceProvider.notifier);
    return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedPlace.state = 'All';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 8,
                        right: 8,
                      ),
                      color: selectedPlace.state == 'All'
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onTertiary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 14,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset(
                                'lib/assets/images/all.png',
                                color: selectedPlace.state == 'All'
                                    ? Theme.of(context).colorScheme.onTertiary
                                    : Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              ' All',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: selectedPlace.state == 'All'
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onTertiary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedPlace.state = 'Fridge';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        right: 8,
                      ),
                      color: selectedPlace.state == 'Fridge'
                          ? Theme.of(context).colorScheme.tertiary
                          :Theme.of(context).colorScheme.onTertiary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 14,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset(
                                'lib/assets/images/fridge.png',
                                color: selectedPlace.state == 'Fridge'
                                    ? Theme.of(context).colorScheme.onTertiary
                                    : Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              ' Fridge',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: selectedPlace.state == 'Fridge'
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onTertiary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedPlace.state = 'Freezer';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        right: 10,
                      ),
                      color: selectedPlace.state == 'Freezer'
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onTertiary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 14,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset(
                                'lib/assets/images/freezer.png',
                                color: selectedPlace.state == 'Freezer'
                                    ? Theme.of(context).colorScheme.onTertiary
                                    : Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              ' Freezer',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: selectedPlace.state == 'Freezer'
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onTertiary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedPlace.state = 'Pantry';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 10,
                      ),
                      color: selectedPlace.state == 'Pantry'
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.onTertiary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                          left: 10,
                          right: 14,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: Image.asset(
                                'lib/assets/images/pantry.png',
                                color: selectedPlace.state == 'Pantry'
                                    ? Theme.of(context).colorScheme.onTertiary
                                    : Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              ' Pantry',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: selectedPlace.state == 'Pantry'
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.onTertiary
                                        : Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
  }
}