import 'package:flutter/material.dart';
import '../test/details_screen.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<int> favoriteIds;
  final List famousPersons;

  // Constructor to receive the favorite IDs and the list of all persons
  FavoritesScreen(this.favoriteIds, this.famousPersons);

  @override
  Widget build(BuildContext context) {
    // Filter the persons that are in the favorites list
    List favoritePersons = famousPersons
        .where((person) => favoriteIds.contains(person['id']))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoritePersons.isEmpty
          ? Center(
        child: Text(
          'No favorites added yet!',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: favoritePersons.length,
        itemBuilder: (context, index) {
          final person = favoritePersons[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://image.tmdb.org/t/p/w200${person['profile_path']}',
                ),
              ),
              title: Text(person['name']),
              subtitle: Text('Popularity: ${person['popularity']}'),
              trailing: IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                onPressed: () {
                  // Remove from favorites action
                  favoriteIds.remove(person['id']);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${person['name']} removed from favorites!'),
                    ),
                  );
                },
              ),
              onTap: () {
                // Navigate to details screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(person['id']),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
