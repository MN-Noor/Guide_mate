import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guide_mate_project/favorites_manager.dart';
import 'profile_page.dart';
import 'profiles/guide_profile.dart';
import 'package:provider/provider.dart';
import 'profiles/tourist_profile.dart';
import 'profiles/travel_agency_profile.dart';
import 'plan_trip/plan_trip_page.dart';
import 'details_page.dart';
import 'virtual_tour_page.dart';
import 'favorites_page.dart';
import 'trips/addTrip.dart';
import 'navigation_helper.dart';

class HomePage extends StatefulWidget {
  final String email; // Add email parameter

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePageContent(),
    FavoritesPage(),
    Center(child: Text('Bookings Page')), // Placeholder for Bookings Page
    Center(child: Text('Profile Page')), // Placeholder for Profile Page
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      _navigateToProfilePage();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _navigateToProfilePage() async {
    try {
      await NavigationHelper.navigateToProfile(
          widget.email, context); // Pass the email to the navigation helper
    } catch (e) {
      print('Error navigating to profile page: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error navigating to profile page')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Mate'),
        backgroundColor: Colors.teal,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace with actual logic to fetch username based on the email
    String username = ' ';

    return Column(
      children: [
        // Top section with profile, welcome, and Plan A Trip button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage:
                    const AssetImage('assets/images/profile_image.png'),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfilePage()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Welcome $username', // Replace with actual username logic
                style: TextStyle(color: Colors.teal),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlanTripPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Plan A Trip',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // Search and filter section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.search, color: Colors.teal),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Discover a city',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.filter_list, color: Colors.teal),
                ),
              ],
            ),
          ),
        ),
        // Trips from Firebase
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Trips').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No trips available.'));
                }
                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return _buildTripCard(data, context);
                  }).toList(),
                );
              },
            ),
          ),
        ),
        // Explore virtual tour button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.all(16),
                  child: VirtualTourPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Explore Virtual Tour',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildTripCard(Map<String, dynamic> tripData, BuildContext context) {
    final favoritesManager =
        Provider.of<FavoritesManager>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              title: tripData['trip_name'] ?? 'No name',
              location: tripData['destination'] ?? 'No destination',
              description: tripData['description'] ?? 'No description',
              imageUrl: (tripData['media_files'] != null &&
                      tripData['media_files'].isNotEmpty)
                  ? tripData['media_files'][0]
                  : 'assets/images/default_trip_image.png',
              imageUrls: (tripData['media_files'] != null &&
                      tripData['media_files'].isNotEmpty)
                  ? List<String>.from(tripData['media_files'])
                  : ['assets/images/default_trip_image.png'],
              price: tripData['price']?.toDouble() ?? 0.0,
              rating: tripData['rating']?.toDouble() ?? 0.0,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  (tripData['media_files'] != null &&
                          tripData['media_files'].isNotEmpty)
                      ? tripData['media_files'][0]
                      : 'assets/images/default_trip_image.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tripData['trip_name'] ?? 'No name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    tripData['description'] ?? 'No description',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'From PKR ${tripData['price']?.toString() ?? 'N/A'} per person',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 20,
                          ),
                          Text(
                            (tripData['rating'] ?? 0.0).toString(),
                            style: TextStyle(color: Colors.teal),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {
                          favoritesManager.addFavorite(FavoritesItem(
                            title: tripData['trip_name'] ?? 'No name',
                            location:
                                tripData['destination'] ?? 'No destination',
                            description:
                                tripData['description'] ?? 'No description',
                            imageUrl: (tripData['media_files'] != null &&
                                    tripData['media_files'].isNotEmpty)
                                ? tripData['media_files'][0]
                                : 'assets/images/default_trip_image.png',
                            imageUrls: (tripData['media_files'] != null &&
                                    tripData['media_files'].isNotEmpty)
                                ? List<String>.from(tripData['media_files'])
                                : ['assets/images/default_trip_image.png'],
                            price: tripData['price']?.toDouble() ?? 0.0,
                            rating: tripData['rating']?.toDouble() ?? 0.0,
                          ));
                        },
                      ),
                    ],
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
