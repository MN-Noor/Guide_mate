import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trips App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TripsListScreen(),
    );
  }
}

class TripsListScreen extends StatefulWidget {
  @override
  _TripsListScreenState createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trips List'),
      ),
      body: Container(
        color: Colors.teal, // Set the background color to teal
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Trips').snapshots(),
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
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return _buildTripCard(data, context);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> tripData, BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(tripData['trip_name'] ?? 'No name'),
            subtitle: Text(tripData['description'] ?? 'No description'),
            trailing:
                Text('Price: \$${tripData['price']?.toString() ?? 'N/A'}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Destination: ${tripData['destination'] ?? 'No destination'}'),
          ),
          _buildMediaPreview(tripData['media_files'] ?? []),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Services: ${(tripData['services'] ?? []).join(', ')}'),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(List<dynamic> mediaFiles) {
    if (mediaFiles.isEmpty) {
      return Container();
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaFiles.length,
        itemBuilder: (context, index) {
          String? mediaUrl = mediaFiles[index] as String?;
          if (mediaUrl == null) {
            return Container();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                mediaUrl,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    color: Colors.grey, // Optional: a grey box as a placeholder
                    width: 150,
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.red,
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
