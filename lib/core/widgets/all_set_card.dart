import 'package:flutter/material.dart';

class AllSetCard extends StatelessWidget {
  const AllSetCard({
    super.key,
    required this.selectedPage,
    required this.isEditing,
    required this.total,
    required this.remaining
  });
  final String selectedPage;
  final bool isEditing;
  final int total;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    // --- ALL SET / EDIT ITEMS ---
    return selectedPage == 'TB'
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.onTertiary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      height: 40,
                      width: 40,
                      child: Icon(
                        Icons.assignment_outlined,
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing == false ? 'All set!' : 'Edit items',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing == false
                              ? 'You have $total items to buy'
                              : 'Remove or reorder items',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                    Spacer(),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        shape: StadiumBorder(),
                        foregroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      onPressed: () {},
                      icon: Icon(Icons.check),
                      label: Text(
                        'Done',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        :
          // --- GOOD JOB ---
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onTertiary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          height: 40,
                          width: 40,
                          child: Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good job',
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'You\'ve bought 8 items',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall!.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 30,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset(
                    'lib/assets/images/groceries.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          );
  }
}
