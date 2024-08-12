import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../home_page.dart';
import '../trips/addTrip.dart';

class TravelAgencyProfilePage extends StatefulWidget {
  final String userEmail;

  const TravelAgencyProfilePage({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _TravelAgencyProfilePageState createState() =>
      _TravelAgencyProfilePageState();
}

class _TravelAgencyProfilePageState extends State<TravelAgencyProfilePage> {
  DocumentSnapshot? _agencySnapshot;
  File? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAgencyProfile();
  }

  Future<void> fetchAgencyProfile() async {
    try {
      final agencySnapshot = await FirebaseFirestore.instance
          .collection('agencies')
          .where('email', isEqualTo: widget.userEmail)
          .get();

      if (agencySnapshot.docs.isNotEmpty) {
        setState(() {
          _agencySnapshot = agencySnapshot.docs.first;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Agency not found for email: ${widget.userEmail}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching agency profile: $e');
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
            .child('agency_profile_images/${widget.userEmail}');
        final uploadTask = storageRef.putFile(_profileImage!);
        final snapshot = await uploadTask.whenComplete(() => {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Update Firestore document with the new image URL
        await _agencySnapshot!.reference.update({
          'profilePhoto': downloadUrl,
        });

        fetchAgencyProfile(); // Refresh profile after updating photo
      } catch (e) {
        print('Error updating profile photo: $e');
      }
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

    if (_agencySnapshot == null) {
      return Scaffold(
        body: Center(
          child: Text('Agency data not found for email: ${widget.userEmail}'),
        ),
      );
    }

    Map<String, dynamic> agencyData =
        _agencySnapshot!.data() as Map<String, dynamic>;

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
        title: Text('Travel Agency Profile'),
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
                        : (agencyData['profilePhoto'] != null
                                ? NetworkImage(agencyData['profilePhoto'])
                                : AssetImage('assets/images/agency.png'))
                            as ImageProvider<Object>,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  agencyData['agency_name'].toString(),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 20),
                buildProfileItem('Established Year',
                    agencyData['established_year'].toString()),
                buildProfileItem('Location', agencyData['location'].toString()),
                buildProfileItem(
                    'Specialties', agencyData['specialties']?.join(', ') ?? ''),
                buildProfileItem(
                    'Phone Number', agencyData['phone_number'].toString()),
                buildProfileItem('Email', agencyData['email'].toString()),
                buildProfileItem('Website', agencyData['website'].toString()),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddTripScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Add Timeline',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
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
