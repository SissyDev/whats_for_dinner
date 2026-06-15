import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';
import 'dart:developer' as dev;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'bought_groceries.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_bought_groceries(id TEXT PRIMARY KEY, picture TEXT, category TEXT, name TEXT, quantity TEXT, unit TEXT, place TEXT, description TEXT, notes TEXT, selected INTEGER)',
      );
    },
  );
  return db;
}

class BoughtItemsNotifier extends StateNotifier<List<Ingredient>> {
  BoughtItemsNotifier() : super(const []);

  Future<void> loadGroceries() async {
    final db = await _getDatabase();
    final data = await db.query(
      'user_bought_groceries',
      orderBy: 'name COLLATE NOCASE ASC',
    );
    final groceries = data
        .map(
          (row) => Ingredient(
            id: row['id'] as String,
            picture: row['picture'] as String,
            category: IngredientCategory.values.firstWhere(
              (e) => e.name == row['category'],
              orElse: () => IngredientCategory.other,
            ),
            name: row['name'] as String,
            quantity: row['quantity'] as String,
            unit: row['unit'] as String,
            place: row['place'] as String,
            description: row['description'] as String? ?? '',
            notes: row['notes'] as String? ?? '',
            selected: row['selected'] as int,
          ),
        )
        .toList();
    state = [...groceries];
  }

  Future<void> addGrocery(Ingredient ingredient) async {
    final db = await _getDatabase();
    if (state.any((ing) => ingredient.id == ing.id)) {
      return;
    } else {
      await db.insert('user_bought_groceries', {
        'id': ingredient.id,
        'picture': ingredient.picture,
        'name': ingredient.name,
        'category': ingredient.category.name,
        'quantity': ingredient.quantity,
        'unit': ingredient.unit,
        'place': ingredient.place,
        'description': ingredient.description,
        'notes': ingredient.notes,
        'selected': ingredient.selected,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await loadGroceries();
  }

  Future<void> addGroceries(List<Ingredient> ingredients) async {
    final db = await _getDatabase();
    final batch = db.batch();

    for (final ingredient in ingredients) {
      batch.insert('user_bought_groceries', {
        'id': ingredient.id,
        'picture': ingredient.picture,
        'name': ingredient.name,
        'category': ingredient.category.name,
        'quantity': ingredient.quantity,
        'unit': ingredient.unit,
        'place': ingredient.place,
        'description': ingredient.description,
        'notes': ingredient.notes,
        'selected': ingredient.selected,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
    await loadGroceries();
  }

  Future<void> removeGroceries(Ingredient ingredient, String id) async {
    final db = await _getDatabase();
    await db.delete('user_bought_groceries', where: 'id = ?', whereArgs: [id]);
    state = state.where((ingredient) => ingredient.id != id).toList();
  }

  Future<void> updateSelection(
    Ingredient ingredient,
    String id,
    int selected,
  ) async {
    final db = await _getDatabase();
    await db.update(
      'user_bought_groceries',
      {'selected': selected},
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await loadGroceries();
  }

  Future<void> updateQuantity(
    Ingredient ingredient,
    String id,
    String quantity,
  ) async {
    final db = await _getDatabase();
    await db.update(
      'user_bought_groceries',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await loadGroceries();
  }
}

final boughtItemsProvider =
    StateNotifierProvider<BoughtItemsNotifier, List<Ingredient>>((ref) {
      return BoughtItemsNotifier();
    });
