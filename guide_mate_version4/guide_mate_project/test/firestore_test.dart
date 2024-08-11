import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void fetchAdvertisements() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Example: Fetching advertisements
  QuerySnapshot querySnapshot = await firestore.collection('Users').get();

  for (var doc in querySnapshot.docs) {
    print('User ID: ${doc.id}');
    print('Description: ${doc['Name']}');
    print('Image Path: ${doc['image_path']}');
    print('Profile ID: ${doc['profile_id']}');
    print(
        'Created At: ${doc['created_at']?.toDate()}'); // Convert Firestore Timestamp to DateTime
    print('Updated At: ${doc['updated_at']?.toDate()}');
    print('-----------------------------');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  fetchAdvertisements(); // Fetch advertisements from Firestore

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Advertisement Fetch',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firestore Advertisement Fetch'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              fetchAdvertisements();
            },
            child: const Text('Fetch Advertisements'),
          ),
        ),
      ),
    );
  }
}
