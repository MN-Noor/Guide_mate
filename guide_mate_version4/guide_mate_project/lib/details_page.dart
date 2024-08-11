import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_manager.dart';

class DetailsPage extends StatefulWidget {
  final String title;
  final String location;
  final String description;
  final String imageUrl;
  final List<String> imageUrls; // Added list of image URLs
  final double price;
  final double rating;

  const DetailsPage({
    super.key,
    required this.title,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.imageUrls, // Added list of image URLs
    required this.price,
    required this.rating,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = Provider.of<FavoritesManager>(context, listen: false)
        .isFavorite(FavoritesItem(
      title: widget.title,
      location: widget.location,
      description: widget.description,
      imageUrl: widget.imageUrl,
      imageUrls: widget.imageUrls,
      price: widget.price,
      rating: widget.rating,
    ));
  }

  void toggleFavorite() {
    final favoritesManager =
    Provider.of<FavoritesManager>(context, listen: false);
    final item = FavoritesItem(
      title: widget.title,
      location: widget.location,
      description: widget.description,
      imageUrl: widget.imageUrl,
      imageUrls: widget.imageUrls,
      price: widget.price,
      rating: widget.rating,
    );

    setState(() {
      if (isFavorite) {
        favoritesManager.removeFavorite(item);
      } else {
        favoritesManager.addFavorite(item);
      }
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 250,
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: toggleFavorite,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.location,
                    style: const TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}/Person',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Preview',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: widget.imageUrls.map((imageUrl) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(imageUrl, width: 100),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle book now action
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Book Now'),
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




// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'favorites_manager.dart';
//
// class DetailsPage extends StatefulWidget {
//   final String title;
//   final String location;
//   final String description;
//   final String imageUrl;
//   final List<String> imageUrls;
//   final double price;
//   final double rating;
//
//   const DetailsPage({super.key,
//     required this.title,
//     required this.location,
//     required this.description,
//     required this.imageUrl,
//     required this.imageUrls,
//     required this.price,
//     required this.rating,
//   });
//
//   @override
//   _DetailsPageState createState() => _DetailsPageState();
// }
//
// class _DetailsPageState extends State<DetailsPage> {
//   bool isFavorite = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Stack(
//               children: [
//                 Image.asset(
//                   widget.imageUrl,
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: 250,
//                 ),
//                 Positioned(
//                   top: 40,
//                   left: 20,
//                   child: IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   top: 40,
//                   right: 20,
//                   child: IconButton(
//                     icon: Icon(
//                       isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: isFavorite ? Colors.red : Colors.white,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         isFavorite = !isFavorite;
//                       });
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.location,
//                     style: const TextStyle(color: Colors.blue, fontSize: 16),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '\$${widget.price.toStringAsFixed(2)}/Person',
//                     style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     widget.description,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Preview',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     height: 80,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: [
//                         Image.asset('assets/images/location1.png', width: 100),
//                         Image.asset('assets/images/location2.png', width: 100),
//                         Image.asset('assets/images/location3.png', width: 100),
//                         Image.asset('assets/images/location4.png', width: 100),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle book now action
//                     },
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size(double.infinity, 50),
//                     ),
//                     child: const Text('Book Now'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
