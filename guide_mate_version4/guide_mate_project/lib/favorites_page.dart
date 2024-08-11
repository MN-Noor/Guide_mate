import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_manager.dart';
import 'details_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesManager>(context).favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.teal,
      ),
      body: favorites.isEmpty
          ? Center(child: Text('No favorites added'))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return ListTile(
            leading: Image.network(
              item.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(item.title),
            subtitle: Text(item.location),
            trailing: Text('\$${item.price.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    title: item.title,
                    location: item.location,
                    description: item.description,
                    imageUrl: item.imageUrl,
                    imageUrls: item.imageUrls,
                    price: item.price,
                    rating: item.rating,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'favorites_manager.dart';
// import 'details_page.dart';
//
// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final favorites = Provider.of<FavoritesManager>(context).favorites;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Favorites'),
//         backgroundColor: Colors.teal,
//       ),
//       body: ListView.builder(
//         itemCount: favorites.length,
//         itemBuilder: (context, index) {
//           final item = favorites[index];
//           return ListTile(
//             leading: Image.asset(
//               item.imageUrl,
//               width: 50,
//               height: 50,
//               fit: BoxFit.cover,
//             ),
//             title: Text(item.title),
//             subtitle: Text(item.location),
//             trailing: Text('\$${item.price.toStringAsFixed(2)}'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DetailsPage(
//                     title: item.title,
//                     location: item.location,
//                     description: item.description,
//                     imageUrl: item.imageUrl,
//                     price: item.price,
//                     rating: item.rating,
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
