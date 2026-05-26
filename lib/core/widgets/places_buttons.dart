import 'package:flutter/material.dart';

final List<String> places = ['Fridge', 'Freezer', 'Pantry'];
String selectedPlace = 'Fridge';

class PlacesButtons extends StatefulWidget {
  const PlacesButtons({super.key});
  @override
  State<PlacesButtons> createState() => _PlacesButtonsState();
}

class _PlacesButtonsState extends State<PlacesButtons> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Text(
                    'Add to ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        selectedPlace = 'Fridge';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 8,
                        right: 8,
                      ),
                      color: selectedPlace == 'Fridge'
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
                                'lib/assets/images/fridge.png',
                                color: selectedPlace == 'Fridge'
                                    ? Theme.of(context).colorScheme.onTertiary
                                    : Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              ' Fridge',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: selectedPlace == 'Fridge'
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
                        selectedPlace = 'Freezer';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 4,
                        bottom: 4,
                        right: 10,
                      ),
                      color: selectedPlace == 'Freezer'
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
                                color: selectedPlace == 'Freezer'
                                    ? Theme.of(context).colorScheme.onTertiary
                                    : Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              ' Freezer',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: selectedPlace == 'Freezer'
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
                        selectedPlace = 'Pantry';
                      });
                    },
                    child: Card(
                      margin: const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        right: 10,
                      ),
                      color: selectedPlace == 'Pantry'
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
                                color: selectedPlace == 'Pantry'
                                    ? Theme.of(context).colorScheme.onTertiary
                                    : Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            Text(
                              ' Pantry',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: selectedPlace == 'Pantry'
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