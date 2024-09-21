import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipes_app/model/recipe_detail_model.dart';

class RecipeDetailService {
  final String _apiKey = 'YOUR_API_KEY';

  Future<RecipeDetailModel> fetchRecipeDetail(int recipeId) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$_apiKey&includeNutrition=true');

print(recipeId);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return RecipeDetailModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}
