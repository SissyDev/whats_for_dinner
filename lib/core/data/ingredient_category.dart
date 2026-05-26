import 'package:flutter/material.dart';

enum IngredientCategory {
  bean,
  bread,
  cereal,
  cheese,
  confectionery,
  curd,
  dairy,
  dressing,
  drink,
  fat,
  fish,
  fruit,
  grain,
  juice,
  legume,
  liqueur,
  liquid,
  meat,
  mushroom,
  nut,
  other,
  pasta,
  pastry,
  preserve,
  rice,
  rootVegetable,
  sauce,
  seafood,
  seasoning,
  side,
  spice,
  spirit,
  stock,
  sugar,
  vegetable,
  vinegar,
  wine,
}

extension IngredientCategoryUI on IngredientCategory {
  String get label {
    switch (this) {
      case IngredientCategory.bean: return "Beans";
      case IngredientCategory.bread: return "Bread";
      case IngredientCategory.cereal: return "Cereals";
      case IngredientCategory.cheese: return "Cheese";
      case IngredientCategory.confectionery: return "Sweets";
      case IngredientCategory.curd: return "Curd";
      case IngredientCategory.dairy: return "Dairy";
      case IngredientCategory.dressing: return "Dressings";
      case IngredientCategory.drink: return "Drinks";
      case IngredientCategory.fat: return "Fats & Oils";
      case IngredientCategory.fish: return "Fish";
      case IngredientCategory.fruit: return "Fruit";
      case IngredientCategory.grain: return "Grains";
      case IngredientCategory.juice: return "Juices";
      case IngredientCategory.legume: return "Legumes";
      case IngredientCategory.liqueur: return "Liqueurs";
      case IngredientCategory.liquid: return "Liquids";
      case IngredientCategory.meat: return "Meat";
      case IngredientCategory.mushroom: return "Mushrooms";
      case IngredientCategory.nut: return "Nuts";
      case IngredientCategory.other: return "Others";
      case IngredientCategory.pasta: return "Pasta";
      case IngredientCategory.pastry: return "Pastry";
      case IngredientCategory.preserve: return "Preserves";
      case IngredientCategory.rice: return "Rice";
      case IngredientCategory.rootVegetable: return "Root Vegetables";
      case IngredientCategory.sauce: return "Sauces";
      case IngredientCategory.seafood: return "Seafood";
      case IngredientCategory.seasoning: return "Herbs";
      case IngredientCategory.side: return "Sides";
      case IngredientCategory.spice: return "Spices";
      case IngredientCategory.spirit: return "Spirits";
      case IngredientCategory.stock: return "Stocks";
      case IngredientCategory.sugar: return "Sugars";
      case IngredientCategory.vegetable: return "Vegetables";
      case IngredientCategory.vinegar: return "Vinegars";
      case IngredientCategory.wine: return "Wine";
    }
  }

  String get emoji {
    switch (this) {
      case IngredientCategory.bean: return "🌱";
      case IngredientCategory.bread: return "🍞";
      case IngredientCategory.cereal: return "🌾";
      case IngredientCategory.cheese: return "🧀";
      case IngredientCategory.confectionery: return "🍬";
      case IngredientCategory.curd: return "🥣";
      case IngredientCategory.dairy: return "🥛";
      case IngredientCategory.dressing: return "🥗";
      case IngredientCategory.drink: return "🥤";
      case IngredientCategory.fat: return "🫒";
      case IngredientCategory.fish: return "🐟";
      case IngredientCategory.fruit: return "🍎";
      case IngredientCategory.grain: return "🌾";
      case IngredientCategory.juice: return "🧃";
      case IngredientCategory.legume: return "🌱";
      case IngredientCategory.liqueur: return "🍸";
      case IngredientCategory.liquid: return "💧";
      case IngredientCategory.meat: return "🍖";
      case IngredientCategory.mushroom: return "🍄";
      case IngredientCategory.nut: return "🥜";
      case IngredientCategory.other: return "🏷️";
      case IngredientCategory.pasta: return "🍝";
      case IngredientCategory.pastry: return "🥐";
      case IngredientCategory.preserve: return "🍯";
      case IngredientCategory.rice: return "🍚";
      case IngredientCategory.rootVegetable: return "🥔";
      case IngredientCategory.sauce: return "🍶";
      case IngredientCategory.seafood: return "🦐";
      case IngredientCategory.seasoning: return "🌿";
      case IngredientCategory.side: return "🍟";
      case IngredientCategory.spice: return "🌶️";
      case IngredientCategory.spirit: return "🥃";
      case IngredientCategory.stock: return "🥣";
      case IngredientCategory.sugar: return "🍯";
      case IngredientCategory.vegetable: return "🥬";
      case IngredientCategory.vinegar: return "🍾";
      case IngredientCategory.wine: return "🍷";
    }
  }

  Color get color {
    switch (this) {
      case IngredientCategory.bean: return const Color.fromRGBO(235, 192, 176, 1);
      case IngredientCategory.bread: return const Color.fromARGB(147, 255, 215, 106);
      case IngredientCategory.cereal: return const Color.fromARGB(169, 255, 193, 7);
      case IngredientCategory.cheese: return const Color.fromARGB(125, 255, 235, 59);
      case IngredientCategory.confectionery: return const Color.fromARGB(52, 27, 180, 183); 
      case IngredientCategory.curd: return const Color.fromARGB(135, 96, 125, 139);
      case IngredientCategory.dairy: return const Color.fromARGB(126, 187, 222, 251);
      case IngredientCategory.dressing: return const Color.fromARGB(121, 165, 214, 167);
      case IngredientCategory.drink: return const Color.fromARGB(79, 59, 185, 243);
      case IngredientCategory.fat: return const Color.fromARGB(81, 76, 175, 79);
      case IngredientCategory.fish: return const Color.fromARGB(93, 62, 164, 248);
      case IngredientCategory.fruit: return const Color.fromARGB(132, 255, 82, 82);
      case IngredientCategory.grain: return const Color.fromARGB(128, 219, 181, 32);
      case IngredientCategory.juice: return const Color.fromARGB(134, 255, 172, 64);
      case IngredientCategory.legume: return const Color.fromARGB(255, 235, 192, 176);
      case IngredientCategory.liqueur: return const Color.fromARGB(56, 197, 48, 223);
      case IngredientCategory.liquid: return const Color.fromARGB(68, 96, 125, 139);
      case IngredientCategory.meat: return const Color.fromARGB(76, 244, 67, 54);
      case IngredientCategory.mushroom: return const Color.fromARGB(96, 79, 26, 6);
      case IngredientCategory.nut: return const Color.fromARGB(133, 121, 85, 72);
      case IngredientCategory.other: return const Color.fromARGB(134, 223, 213, 213);
      case IngredientCategory.pasta: return const Color.fromARGB(115, 229, 196, 7);
      case IngredientCategory.pastry: return const Color.fromARGB(82, 249, 94, 146);
      case IngredientCategory.preserve: return const Color.fromARGB(96, 255, 86, 34);
      case IngredientCategory.rice: return const Color.fromARGB(110, 255, 235, 59);
      case IngredientCategory.rootVegetable: return const Color.fromARGB(109, 188, 170, 164);
      case IngredientCategory.sauce: return const Color.fromARGB(120, 229, 178, 115);
      case IngredientCategory.seafood: return const Color.fromARGB(101, 66, 164, 245);
      case IngredientCategory.seasoning: return const Color.fromARGB(122, 76, 175, 79);
      case IngredientCategory.side: return const Color.fromARGB(127, 158, 158, 158);
      case IngredientCategory.spice: return const Color.fromARGB(105, 255, 86, 34);
      case IngredientCategory.spirit: return const Color.fromARGB(61, 190, 48, 215);
      case IngredientCategory.stock: return const Color.fromARGB(101, 188, 170, 164);
      case IngredientCategory.sugar: return const Color.fromARGB(105, 248, 187, 208);
      case IngredientCategory.vegetable: return const Color.fromARGB(98, 76, 175, 79);
      case IngredientCategory.vinegar: return const Color.fromARGB(110, 239, 154, 154);
      case IngredientCategory.wine: return const Color.fromARGB(101, 104, 58, 183);
    }
  }
}