class RecipeModel {
  final String title;
  final String image;
  final String summary;
  final int readyInMinutes;
  final int servings;
  final String sourceUrl;
  final int id;

  RecipeModel({
    required this.title,
    required this.image,
    required this.summary,
    required this.readyInMinutes,
    required this.servings,
    required this.sourceUrl,
    required this.id,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      summary: json['summary'],
      readyInMinutes: json['readyInMinutes'],
      servings: json['servings'],
      sourceUrl: json['sourceUrl'],
    );
  }
}
