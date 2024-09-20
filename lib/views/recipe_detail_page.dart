import 'package:flutter/material.dart';
import 'package:recipes_app/model/recipe_detail_model.dart';
import 'package:recipes_app/service/recipe_detail_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  RecipeDetailPage({required this.recipeId});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Future<RecipeDetailModel> _recipeDetail; // API'den çekilecek veri Future tipinde olacak

  @override
  void initState() {
    super.initState();
    // API isteğini başlatıyoruz
    _recipeDetail = RecipeDetailService().fetchRecipeDetail(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Food Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Geri butonu beyaz
        elevation: 0,
      ),
      body: FutureBuilder<RecipeDetailModel>(
        future: _recipeDetail, // Gelecek veri burada
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text('An error occurred while loading data'));
          } else if (snapshot.hasData) {
            final recipe = snapshot.data!;
            final unescape = HtmlUnescape();
            final cleanedSummary = unescape.convert(recipe.summary.replaceAll(RegExp(r'<[^>]*>'), ''));

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Yemek fotoğrafı
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Resmi kavisli yapmak
                      child: Image.network(
                        recipe.image,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Başlık
                    Text(
                      recipe.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),

                    Divider(), // Alanlar arasında ince bir çizgi

                    // Zaman, Zorluk, Kalori, Popülerlik Bilgileri
                    _buildInfoRow(Icons.timer, 'Time', '${recipe.readyInMinutes} min'),
                    _buildInfoRow(Icons.restaurant, 'Serving', '${recipe.servings}'),
                    _buildInfoRow(Icons.attach_money, 'Price', '\$${recipe.pricePerServing.toStringAsFixed(2)} / serving'),
                    _buildInfoRow(Icons.thumb_up, 'Popularity', recipe.veryPopular ? "Popular" : "Less Popular"),
                    _buildInfoRow(Icons.health_and_safety, 'Is it healthy?', recipe.veryHealthy ? "Yes" : "No"),
                    _buildInfoRow(Icons.nature_people, 'Vegetarian?', recipe.vegetarian ? "Yes" : "No"),
                    _buildInfoRow(Icons.emoji_nature, 'Vegan?', recipe.vegan ? "Yes" : "No"),
                    _buildInfoRow(Icons.local_dining, 'Gluten-free?', recipe.glutenFree ? "Yes" : "No"),
                    SizedBox(height: 10),

                    Divider(),

                    // Tarif özeti ve açıklama
                    Text(
                      "Recipe Summary",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      cleanedSummary, // HTML etiketlerinden arındırılmış içerik
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    SizedBox(height: 20),

                    Divider(),

                    // Malzemeler başlığı
                    Text(
                      "Ingredients",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),

                    // Malzemeler listesi
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // İçerik kaydırma devre dışı
                      itemCount: recipe.ingredients.length,
                      itemBuilder: (context, index) {
                        final ingredient = recipe.ingredients[index];
                        return ListTile(
                          leading: Image.network(
                            'https://spoonacular.com/cdn/ingredients_100x100/${ingredient.image}',
                            width: 50,
                            height: 50,
                          ),
                          title: Text(ingredient.name),
                          subtitle: Text('${ingredient.amount} ${ingredient.unit}'),
                        );
                      },
                    ),
                    SizedBox(height: 20),

                    Divider(),

                    // Tarife Git butonu
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          _launchURL(recipe.sourceUrl);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          child: Text(
                            'Go to Recipe',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('No recipe found'));
        },
      ),
    );
  }

  // Bilgi satırı yapıcı fonksiyon
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green), // İkon
          SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  // URL açma fonksiyonu
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
