import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';

import 'package:whats_for_dinner/core/providers/storage_provider.dart';

final List<String> unitList = [
  'pcs',
  'g',
  'kg',
  'ml',
  'l',
  'oz',
  'lb',
  'fl oz',
];

class EditIngredient extends ConsumerStatefulWidget {
  const EditIngredient({super.key, required this.ingredient});
  final Ingredient ingredient;
  @override
  ConsumerState<EditIngredient> createState() => _EditIngredientState();
}

class _EditIngredientState extends ConsumerState<EditIngredient> {
  String dropDownValue = unitList[0];
  TextEditingController qtyController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  int quantity = 1;
  Timer? _timer;
  int _currentDelay = 300;
  String selectedPlace = '';

  @override
  void initState() {
    selectedPlace = widget.ingredient.place;
    qtyController.text = widget.ingredient.quantity;
    dropDownValue = widget.ingredient.unit;
    notesController.text = widget.ingredient.notes ?? '';
    super.initState();
  }

void _startIncrementTimer() {
  _currentDelay = 300;

  _timer?.cancel();

  void repeat() {
    _timer = Timer(Duration(milliseconds: _currentDelay), () {
      _increment();

      _currentDelay = (_currentDelay * 0.85).toInt().clamp(30, 300);

      repeat();
    });
  }

  repeat();
}

void _startDecrementTimer() {
  _currentDelay = 300;

  _timer?.cancel();

  void repeat() {
    _timer = Timer(Duration(milliseconds: _currentDelay), () {
      _decrement();

      _currentDelay = (_currentDelay * 0.85).toInt().clamp(30, 300);

      repeat();
    });
  }

  repeat();
}

void _increment() {
  setState(() {
    quantity = int.tryParse(qtyController.text) ?? 1;

    if (quantity < 9999) {
      qtyController.text = (quantity + 1).toString();
    }
  });
}

void _decrement() {
  setState(() {
    quantity = int.tryParse(qtyController.text) ?? 1;

    if (quantity > 1) {
      qtyController.text = (quantity - 1).toString();
    }
  });
}

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    qtyController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(storageProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // --- APPBAR ---
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Ingredient',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              'Update your ingredient details',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      // --- CIRCLE IMAGE ---
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: widget.ingredient.category.color,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: Text(
                          widget.ingredient.category.emoji,
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  // --- TITLE + CATEGORY ---
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white, Colors.transparent],
                                stops: [0.8, 1.0],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight,
                                    ),
                                    child: Align(
                                      alignment: AlignmentGeometry.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          widget.ingredient.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Divider(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            height: 30,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: widget.ingredient.category.color,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 12,
                                top: 6,
                                bottom: 6,
                              ),
                              child: Center(
                                child: Text(
                                  widget.ingredient.category.label,
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // --- QUANTITY ---
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              bottom: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'QUANTITY',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: _decrement,
                                        onTapDown: (_) =>
                                            _startDecrementTimer(),
                                        onTapUp: (_) => _stopTimer(),
                                        onTapCancel: () => _stopTimer(),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 6,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Icon(
                                                Icons.remove,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          autocorrect: false,
                                          controller: qtyController,
                                          cursorColor: Colors.transparent,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: false,
                                                signed: false,
                                              ),
                                          maxLines: 1,
                                          maxLength: 4,
                                          textAlign: TextAlign.center,
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                          decoration: InputDecoration(
                                            hint: Center(
                                              child: Text(quantity.toString()),
                                            ),
                                            counterText: '',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 2,
                                                  horizontal: 12,
                                                ),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              quantity =
                                                  int.tryParse(
                                                    qtyController.text,
                                                  ) ??
                                                  1;
                                              if (quantity != 0) {
                                                qtyController.text = value;
                                              } else {
                                                quantity = 1;
                                                qtyController.text = '1';
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _increment,
                                        onTapDown: (_) =>
                                            _startIncrementTimer(),
                                        onTapUp: (_) => _stopTimer(),
                                        onTapCancel: () => _stopTimer(),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 6,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Icon(Icons.add, size: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // --- UNIT ---
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UNIT',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 40,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outline,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      alignment: AlignmentGeometry.centerLeft,
                                      underline: Divider(
                                        color: Colors.transparent,
                                      ),
                                      value: dropDownValue,
                                      items: unitList.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Row(
                                            children: [
                                              Text(
                                                e,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                              const SizedBox(width: 25),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == null) {
                                            return;
                                          }
                                          dropDownValue = value;
                                        });
                                      },
                                    ),
                                  ), //menu tendina prescelta -- poi aggiungi limite low
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Divider(),
                      // --- STORAGE PLACE ---
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'STORAGE PLACE',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // --- Fridge ---
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedPlace = 'Fridge';
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: selectedPlace == 'Fridge'
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.surface
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.onSecondary,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 10,
                                              top: 8,
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 18,
                                                  child: Image.asset(
                                                    'lib/assets/images/fridge.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Fridge',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // --- Freezer ---
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedPlace = 'Freezer';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: selectedPlace == 'Freezer'
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.surface
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.onSecondary,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 10,
                                            top: 8,
                                            bottom: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 18,
                                                child: Image.asset(
                                                  'lib/assets/images/freezer.png',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Freezer',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // --- Pantry ---
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedPlace = 'Pantry';
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 3,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: selectedPlace == 'Pantry'
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.surface
                                                : Theme.of(
                                                    context,
                                                  ).colorScheme.onSecondary,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 10,
                                              top: 8,
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 18,
                                                  child: Image.asset(
                                                    'lib/assets/images/pantry.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Pantry',
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),
                      // --- NOTES ---
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 6,
                          left: 8,
                          right: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'NOTES (OPTIONAL)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 90,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.multiline,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: null,
                                controller: notesController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(8),
                                  filled: false,
                                  hint: Text(
                                    'Add notes about this ingredient...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                          fontSize: 13,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // --- INGREDIENT DETAILS ---
              widget.ingredient.description != ''
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 8,
                      ),
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 6),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.info,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            VerticalDivider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DETAILS',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: SizedBox(
                                      width: 200,
                                      height: 60,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          widget.ingredient.description ?? '',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              Spacer(),
              // --- BUTTONS ---
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        ref
                            .read(storageProvider.notifier)
                            .updateIngredients(
                              widget.ingredient.id,
                              qtyController.text,
                              dropDownValue,
                              selectedPlace,
                              notesController.text,
                            );
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 10,
                          ),
                          child: Center(
                            child: Text(
                              'Save Changes',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onTertiary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
