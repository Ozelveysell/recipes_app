import 'package:flutter/material.dart';
import 'package:recipes_app/service/recipe_service.dart';
import 'package:recipes_app/model/recipe_model.dart';
import 'package:recipes_app/views/recipe_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<RecipeModel>> _recipes;
  List<RecipeModel> _filteredRecipes = [];
  String _searchQuery = '';
  String _sortOption = '';
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _recipes = RecipeService().fetchRecipes();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= 200) {
      setState(() {
        _showBackToTopButton = true; // Kaydırma 200 pikselden fazlaysa butonu göster
      });
    } else {
      setState(() {
        _showBackToTopButton = false; // Daha yukarıdaysa butonu gizle
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void _filterRecipes(List<RecipeModel> recipes) {
    _filteredRecipes = recipes
        .where((recipe) =>
            recipe.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
    _sortRecipes();
  }

  void _sortRecipes() {
    if (_sortOption == 'Portion (Low to Large)') {
      _filteredRecipes.sort((a, b) => a.servings.compareTo(b.servings));
    } else if (_sortOption == 'Portion (Most to Few)') {
      _filteredRecipes.sort((a, b) => b.servings.compareTo(a.servings));
    } else if (_sortOption == 'Duration (Low to High)') {
      _filteredRecipes.sort((a, b) => a.readyInMinutes.compareTo(b.readyInMinutes));
    } else if (_sortOption == 'Duration (Most to Low)') {
      _filteredRecipes.sort((a, b) => b.readyInMinutes.compareTo(a.readyInMinutes));
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 240,
          child: Column(
            children: [
              ListTile(
                title: Text('Portion (Low to Large)'),
                onTap: () {
                  setState(() {
                    _sortOption = 'Portion (Low to Large)';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Portion (Most to Few)'),
                onTap: () {
                  setState(() {
                    _sortOption = 'Portion (Most to Few)';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Duration (Low to High)'),
                onTap: () {
                  setState(() {
                    _sortOption = 'Duration (Low to High)';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Duration (Most to Low)'),
                onTap: () {
                  setState(() {
                    _sortOption = 'Duration (Most to Low)';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes' , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.green,
        
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              // Arama Çubuğu ve Sıralama Butonu
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for a recipe...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 5.0,),
                   Container(
  decoration: BoxDecoration(
    color: Colors.green, // Arka plan rengi
    shape: BoxShape.circle, // İkonun etrafını yuvarlak yapmak için
  ),
  child: IconButton(
    icon: Icon(Icons.sort, color: Colors.white), // İkon rengi
    onPressed: _showSortOptions, // Tıklanma işlevi
  ),
)

                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<RecipeModel>>(
                  future: _recipes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('An error occurred while loading recipes'));
                    } else {
                      _filterRecipes(snapshot.data!); // Burada setState() kullanılmadığına dikkat edin
                      return ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(10),
                        itemCount: _filteredRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _filteredRecipes[index];
                          return RecipeCard(recipe: recipe);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Üste dön butonu
        if (_showBackToTopButton)
  Positioned(
    bottom: 20,
    right: 20,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30), // Border radius 30 verildi
      child: Container(
        color: Colors.green, // Arka plan rengi
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: _scrollToTop,
          child: Icon(Icons.arrow_upward, color: Colors.white),
        ),
      ),
    ),
  ),

        ],
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;

  RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Görseli ortalama ve kavisli yapma
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Image.network(
                  recipe.image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Başlık
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                recipe.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 5),
            // Süre, porsiyon ve puan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Serving: ${recipe.servings}'),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Detaylara git butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(recipeId: recipe.id),
                        ),
                      );
                    },
                    child: Text('Detail'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      // Butona tıklanınca yapılacak işlem
                    },
                    child: Text(
                      recipe.readyInMinutes <= 20
                          ? 'Easy'
                          : recipe.readyInMinutes <= 50
                              ? 'Middle'
                              : 'Difficult',
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green, // Yazı rengi beyaz
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      // Butona tıklanınca yapılacak işlem
                    },
                    child: Text('${recipe.readyInMinutes} min'),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
