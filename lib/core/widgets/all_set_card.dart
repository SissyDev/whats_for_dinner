import 'package:flutter/material.dart';

class AllSetCard extends StatefulWidget {
  const AllSetCard({
    super.key,
    required this.selectedPage,
    required this.onEdit,
    required this.total,
    required this.remaining,
  });
  final String selectedPage;
  final Function(bool) onEdit;
  final int total;
  final int remaining;

  @override
  State<AllSetCard> createState() => _AllSetCardState();
}

class _AllSetCardState extends State<AllSetCard> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    // --- ALL SET / EDIT ITEMS ---
    return widget.selectedPage == 'TB'
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
                          isEditing ? 'Edit items' : 'All set!',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing
                              ? 'Remove or reorder items'
                              : 'You have ${widget.total} items to buy',
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
                      onPressed: () {
                        setState(() {
                          if (!isEditing) {
                            widget.onEdit(true);
                            isEditing = true;
                          } else {
                            widget.onEdit(false);
                            isEditing = false;
                          }
                        });
                      },
                      icon: isEditing ? Icon(Icons.check) : Icon(Icons.edit),
                      label: Text(
                        isEditing ? 'Done' : 'Edit',
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
