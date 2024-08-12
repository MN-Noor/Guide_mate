import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../home_page.dart';
import '../trips/addTrip.dart';
import 'package:intl/intl.dart';

class GuideProfilePage extends StatefulWidget {
  final String userEmail;

  const GuideProfilePage({Key? key, required this.userEmail}) : super(key: key);

  @override
  _GuideProfilePageState createState() => _GuideProfilePageState();
}

class _GuideProfilePageState extends State<GuideProfilePage> {
  DocumentSnapshot? _userSnapshot;
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
          .collection('guides')
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
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });

    if (_profileImage != null && _userSnapshot != null) {
      try {
        await _userSnapshot!.reference.update({
          'profilePhoto': _profileImage!.path,
        });
        fetchUserProfile(); // Fetch updated user profile
      } catch (e) {
        print('Error updating profile photo: $e');
      }
    }
  }

  String formatDates(List<dynamic> dates) {
    if (dates.isEmpty) return '';
    final dateFormat = DateFormat('d MMMM, yyyy');
    List<String> formattedDates = dates
        .map((date) {
          if (date is String) {
            return dateFormat.format(DateTime.parse(date));
          }
          return '';
        })
        .where((date) => date.isNotEmpty)
        .toList();
    return formattedDates.join(', ');
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

    Map<String, dynamic> userData =
        _userSnapshot!.data() as Map<String, dynamic>;

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
        title: Text('Guide Profile'),
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
                    radius: 100, // Increased size
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (userData['profilePhoto'] != null
                            ? FileImage(File(userData['profilePhoto']))
                                as ImageProvider
                            : AssetImage('assets/images/img.png')),
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
                buildProfileItem(
                    'Years of Experience', userData['experience'].toString()),
                buildProfileItem('Specialty Areas',
                    userData['speciality_areas']?.join(', ') ?? ''),
                buildProfileItem('Available Dates',
                    formatDates(userData['available_dates'] ?? [])),
                buildProfileItem('Preferred Meeting Location',
                    userData['preferred_meeting_locations']?.join(', ') ?? ''),
                buildProfileItem(
                    'Phone Number', userData['phone_number'].toString()),
                buildProfileItem('Email', userData['email'].toString()),
                buildProfileItem(
                    'Important Note', userData['importantNote'].toString()),
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
                    'Add Trip',
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                // SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     // Implement log out functionality
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   child: Text(
                //     'Log Out',
                //     style: TextStyle(color: Colors.teal),
                //   ),
                // ),
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

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 30);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
