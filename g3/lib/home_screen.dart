import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../test/details_screen.dart';
import '../test/favorites_screen.dart';
import '../test/login_screen.dart';
import 'details_screen.dart';
import 'favourites_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List famousPersons = [];
  Set<int> favoriteIds = {};
  List filteredPersons = [];
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    fetchFamousPersons();
  }

  Future<void> fetchFamousPersons() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/id?api_key=2dfe23358236069710a379edd4c65a6b'));
    if (response.statusCode == 200) {
      setState(() {
        famousPersons = json.decode(response.body)['results'];
        filteredPersons = famousPersons;
      });
    }
  }

  void toggleFavorite(int id) {
    setState(() {
      final person = famousPersons.firstWhere((p) => p['id'] == id);
      if (favoriteIds.contains(id)) {
        favoriteIds.remove(id);
        person['popularity'] -= 1;
      } else {
        favoriteIds.add(id);
        person['popularity'] += 1;
      }
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      filteredPersons = famousPersons
          .where((person) =>
          person['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void sortByPopularity() {
    setState(() {
      filteredPersons
          .sort((a, b) => b['popularity'].compareTo(a['popularity']));
    });
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> refreshList() async {
    await fetchFamousPersons();
  }

  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Famous Persons'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(
                  famousPersons: famousPersons,
                  onSearch: filterSearchResults,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: sortByPopularity,
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesScreen(favoriteIds, famousPersons),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshList,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: filteredPersons.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredPersons.length,
        itemBuilder: (context, index) {
          final person = filteredPersons[index];
          return SlideAnimation(
            child: Card(
              elevation: 4,
              margin:
              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://image.tmdb.org/t/p/w200${person['profile_path']}',
                  ),
                ),
                title: Text(person['name']),
                subtitle: Row(
                  children: [
                    Icon(Icons.people,
                        size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Fans: ${person['popularity'].toInt()}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    favoriteIds.contains(person['id'])
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoriteIds.contains(person['id'])
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () => toggleFavorite(person['id']),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(person['id']),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List famousPersons;
  final Function(String) onSearch;

  CustomSearchDelegate(
      {required this.famousPersons, required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    final searchResults = famousPersons
        .where((person) =>
        person['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final person = searchResults[index];
        return ListTile(
          title: Text(person['name']),
          onTap: () {
            close(context, null);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(person['id']),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = famousPersons
        .where((person) =>
        person['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final person = suggestions[index];
        return ListTile(
          title: Text(person['name']),
          onTap: () {
            query = person['name'];
            showResults(context);
          },
        );
      },
    );
  }
}

class SlideAnimation extends StatelessWidget {
  final Widget child;

  SlideAnimation({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
      duration: Duration(milliseconds: 300),
      child: child,
      builder: (context, offset, widget) {
        return Transform.translate(offset: offset, child: widget);
      },
    );
  }
}
