import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Guide Mate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Book a guide'),
            onTap: () {
              // Navigate to Book a guide page
            },
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('Ratings and reviews'),
            onTap: () {
              // Navigate to Ratings and reviews page
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile Management'),
            onTap: () {
              // Navigate to Profile Management page
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              // Navigate to About page
            },
          ),
        ],
      ),
    );
  }
}
