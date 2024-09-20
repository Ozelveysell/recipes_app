class RecipeDetailModel {
  final int id;
  final String title;
  final String image;
  final int readyInMinutes;
  final int servings;
  final String summary;
  final String sourceUrl;
  final bool vegetarian;
  final bool vegan;
  final bool glutenFree;
  final bool dairyFree;
  final bool veryHealthy;
  final bool veryPopular;
  final double pricePerServing;
  final List<ExtendedIngredient> ingredients; // Malzemeler listesi

  RecipeDetailModel({
    required this.id,
    required this.title,
    required this.image,
    required this.readyInMinutes,
    required this.servings,
    required this.summary,
    required this.sourceUrl,
    required this.vegetarian,
    required this.vegan,
    required this.glutenFree,
    required this.dairyFree,
    required this.veryHealthy,
    required this.veryPopular,
    required this.pricePerServing,
    required this.ingredients,
  });

  // JSON'dan verileri çekerken kullanılacak factory constructor
  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) {
    return RecipeDetailModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      summary: json['summary'],
      sourceUrl: json['spoonacularSourceUrl'],
      vegetarian: json['vegetarian'],
      vegan: json['vegan'],
      glutenFree: json['glutenFree'],
      dairyFree: json['dairyFree'],
      veryHealthy: json['veryHealthy'],
      veryPopular: json['veryPopular'],
      pricePerServing: json['pricePerServing'].toDouble(),
      ingredients: (json['extendedIngredients'] as List)
          .map((ingredientJson) => ExtendedIngredient.fromJson(ingredientJson))
          .toList(),
    );
  }
}

class ExtendedIngredient {
  final String name;
  final String original;
  final double amount;
  final String unit;
  final String image;

  ExtendedIngredient({
    required this.name,
    required this.original,
    required this.amount,
    required this.unit,
    required this.image,
  });

  // JSON'dan malzemeleri çekerken kullanılacak factory constructor
  factory ExtendedIngredient.fromJson(Map<String, dynamic> json) {
    return ExtendedIngredient(
      name: json['name'],
      original: json['original'],
      amount: json['amount'].toDouble(),
      unit: json['unit'] ?? '',
      image: json['image'],
    );
  }
}
