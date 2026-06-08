import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:whats_for_dinner/core/data/ingredient.dart';
import 'package:whats_for_dinner/core/data/ingredient_category.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

final units = ['1 pcs, 150 g, 150 ml, 4 oz, 4 fl oz'];

final runningOutProvider = Provider<List<Ingredient>>((ref) {
  final allIngredients = ref.watch(storageProvider);
  return allIngredients.where((ingredient) {
    final unit = ingredient.unit;
    final qty = int.tryParse(ingredient.quantity) ?? 0;
    if (qty < 0) {
      return false;
    }
    if (unit == 'pcs') {
      return qty == 1;
    }
    if (unit == 'g' || unit == 'ml') {
      return qty <= 150 && qty > 0;
    }
    if (unit == 'oz' || unit == 'fl oz') {
      return qty <= 4 && qty > 0;
    }
    return false;
  }).toList();
});

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'ingredients.db'),
    version: 4,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_ingredients(id TEXT PRIMARY KEY, picture TEXT, category TEXT, name TEXT, quantity TEXT, unit TEXT, place TEXT, description TEXT, notes TEXT)',
      );
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          'ALTER TABLE user_ingredients ADD COLUMN category TEXT',
        );
      }
      if (oldVersion < 3) {
        await db.execute(
          'ALTER TABLE user_ingredients ADD COLUMN description TEXT',
        );
      }
      if (oldVersion < 4) {
        await db.execute('ALTER TABLE user_ingredients ADD COLUMN notes TEXT');
      }
    },
  );
  return db;
}

class StorageNotifier extends StateNotifier<List<Ingredient>> {
  StorageNotifier() : super(const []);

  Future<void> loadIngredients() async {
    final db = await _getDatabase();
    final data = await db.query(
      'user_ingredients',
      orderBy: 'name COLLATE NOCASE ASC',
    );
    final ingredients = data
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
          ),
        )
        .toList();
    state = [...ingredients];
  }

  Future<void> addNewIngredient(
    String id,
    String picture,
    String name,
    IngredientCategory category,
    String quantity,
    String unit,
    String place,
    String? description,
    String? notes,
  ) async {
    final newIngredient = Ingredient(
      id: id,
      picture: picture,
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      place: place,
      description: description,
      notes: notes,
    );
    final db = await _getDatabase();
    await db.insert('user_ingredients', {
      'id': newIngredient.id,
      'picture': newIngredient.picture,
      'name': newIngredient.name,
      'category': newIngredient.category.name,
      'quantity': newIngredient.quantity,
      'unit': newIngredient.unit,
      'place': newIngredient.place,
      'description': newIngredient.description,
      'notes': newIngredient.notes,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await loadIngredients();
  }

  Future<void> addNewIngredients(List<Ingredient> ingredients) async {
    final db = await _getDatabase();
    final batch = db.batch();

    for (final ingredient in ingredients) {
      batch.insert('user_ingredients', {
        'id': ingredient.id,
        'picture': ingredient.picture,
        'name': ingredient.name,
        'category': ingredient.category.name,
        'quantity': ingredient.quantity,
        'unit': ingredient.unit,
        'place': ingredient.place,
        'description': ingredient.description,
        'notes': ingredient.notes,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
    await loadIngredients();
  }

  Future<void> removeData(Ingredient ingredient, String id) async {
    final db = await _getDatabase();
    await db.delete('user_ingredients', where: 'id = ?', whereArgs: [id]);
    state = state.where((ingredient) => ingredient.id != id).toList();
  }

  Future<void> updateIngredients(
    String id,
    String quantity,
    String unit,
    String place,
    String notes,
  ) async {
    final db = await _getDatabase();
    await db.update(
      'user_ingredients',
      {'quantity': quantity, 'unit': unit, 'place': place, 'notes': notes},
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await loadIngredients();
  }
}

final storageProvider =
    StateNotifierProvider<StorageNotifier, List<Ingredient>>((ref) {
      return StorageNotifier();
    });
