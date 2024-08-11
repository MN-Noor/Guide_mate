
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'profiles/tourist_profile.dart';
import 'profiles/guide_profile.dart';
import 'profiles/travel_agency_profile.dart';

class NavigationHelper {
  static Future<void> navigateToProfile(String userEmail, BuildContext context) async {
    try {
      final userSnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: userEmail).get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs.first.data();
        final userType = userData['user_type'].toString(); // Ensure user_type is a String

        switch (userType) {
          case 'Tourist':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TouristProfilePage(userEmail: userEmail)),
            );
            break;
          case 'Guide':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => GuideProfilePage(userEmail: userEmail)),
            );
            break;
          case 'Travel Agency':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TravelAgencyProfilePage(userEmail: userEmail)),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User type not recognized')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      print('Error navigating to profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error navigating to profile')));
    }
  }
}
