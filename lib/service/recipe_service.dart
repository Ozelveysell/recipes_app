import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipes_app/model/recipe_model.dart';

class RecipeService {
  final String apiKey = '96e51321c4a746819f7304de0f133043';
  final String baseUrl = 'https://api.spoonacular.com/recipes/complexSearch';

  Future<List<RecipeModel>> fetchRecipes() async {
    try {
      final url = Uri.parse('$baseUrl?apiKey=$apiKey&number=50&addRecipeInformation=true');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> results = data['results'];
        return results.map((recipe) => RecipeModel.fromJson(recipe)).toList();
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Tarifler yüklenirken bir hata oluştu');
    }
  }
}
