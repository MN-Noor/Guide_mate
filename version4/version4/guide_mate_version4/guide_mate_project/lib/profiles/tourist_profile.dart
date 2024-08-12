import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'edit_tourist_profile.dart';
import '../home_page.dart';

class TouristProfilePage extends StatefulWidget {
  final String userEmail;

  const TouristProfilePage({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _TouristProfilePageState createState() => _TouristProfilePageState();
}

class _TouristProfilePageState extends State<TouristProfilePage> {
  DocumentSnapshot<Map<String, dynamic>>? _userSnapshot;
  File? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('tourists')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        setState(() {
          _userSnapshot = userSnapshot.docs.first;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('User not found for email: ${widget.userEmail}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user profile: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Upload the image to Firebase Storage and get the URL
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('tourist_profile_images/${widget.userEmail}');
        final uploadTask = storageRef.putFile(_profileImage!);
        final snapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore document with the new image URL
        await _userSnapshot!.reference.update({
          'profilePhoto': downloadUrl,
        });

        fetchUserProfile(); // Refresh profile after updating photo
      } catch (e) {
        print('Error updating profile photo: $e');
      }
    }
  }

  void navigateToEditProfile() {
    if (_userSnapshot != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditTouristPage(
            userSnapshot: _userSnapshot!,
          ),
        ),
      ).then((_) {
        fetchUserProfile(); // Refresh profile after edit
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_userSnapshot == null) {
      return Scaffold(
        body: Center(
          child: Text('User data not found for email: ${widget.userEmail}'),
        ),
      );
    }

    Map<String, dynamic> userData = _userSnapshot!.data()!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(email: widget.userEmail)),
            );
          },
        ),
        title: Text(' '),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: navigateToEditProfile,
          // ),
        ],
      ),
      body: Container(
        color: Colors.teal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (userData['profilePhoto'] != null
                                ? NetworkImage(userData['profilePhoto'])
                                : AssetImage('assets/images/tourist.png'))
                            as ImageProvider<Object>,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  userData['full_name'].toString(),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),
                buildProfileItem('Gender', userData['gender'].toString()),
                buildProfileItem('Languages Spoken',
                    userData['languages_spoken']?.join(', ') ?? ''),
                buildProfileItem('Preferred Destinations',
                    userData['preferred_destinations']?.join(', ') ?? ''),
                buildProfileItem('Preferred Activities',
                    userData['preferred_activities']?.join(', ') ?? ''),
                buildProfileItem(
                    'Phone Number', userData['phone_number'].toString()),
                buildProfileItem('Email', userData['email'].toString()),
                buildProfileItem('Important Note',
                    userData['important_note']?.toString() ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
