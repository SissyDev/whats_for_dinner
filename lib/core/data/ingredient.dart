import 'package:whats_for_dinner/core/data/ingredient_category.dart';

class Ingredient {
  Ingredient({
    required String id,
    required this.category,
    required this.name,
    this.picture = '',
    this.quantity = '1',
    this.unit = 'pcs',
    this.place = 'All',
    this.description = '',
    this.notes = '',
  }) : id = id.isEmpty ? name.toLowerCase().trim() : id;
  final String id;
  final IngredientCategory category;
  final String picture;
  final String name;
  String quantity;
  String unit;
  String place;
  String? description;
  String? notes;
}
