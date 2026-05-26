class Recipe {
  Recipe({
    required String id,
    required this.picture,
    required this.title,
    this.category = '',
    this.area = 'none',
    this.instructions = '',
    this.tags = '',
    this.youtube = '',
    required this.ingredientsList,
    required this.unitList,
    this.missingIngredients = 0,
  }) : id = id.isEmpty ? title.toLowerCase().trim() : id;
  final String id;
  final String picture;
  final String title;
  final String category;
  final String area;
  final String instructions;
  final String tags;
  final String youtube;
  final List<String> ingredientsList;
  final List<String> unitList;
  int missingIngredients;
}

enum RecipeCategory {
  all,
  beef,
  breakfast,
  chicken,
  dessert,
  goat,
  lamb,
  miscellaneous,
  pasta,
  pork,
  seafood,
  side,
  starter,
  vegan,
  vegetarian;

  String get jsonKey => name;
}
