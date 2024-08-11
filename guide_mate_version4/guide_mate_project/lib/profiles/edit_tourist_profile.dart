import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditTouristPage extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> userSnapshot;

  const EditTouristPage({
    Key? key,
    required this.userSnapshot,
  }) : super(key: key);

  @override
  _EditTouristPageState createState() => _EditTouristPageState();
}

class _EditTouristPageState extends State<EditTouristPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _importantNoteController;
  late TextEditingController _preferredActivitiesController;
  File? _profileImage;

  String _gender = '';
  String _ageGroup = '';
  List<String> _languagesSpoken = [];
  List<String> _preferredDestinations = [];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userSnapshot['name']);
    _phoneNumberController = TextEditingController(text: widget.userSnapshot['contact_details']);
    _emailController = TextEditingController(text: widget.userSnapshot['email']);
    _importantNoteController = TextEditingController(text: widget.userSnapshot['importantNote']);
    _preferredActivitiesController = TextEditingController(text: widget.userSnapshot['preferredActivities']);
    _gender = widget.userSnapshot['gender'];
    _ageGroup = widget.userSnapshot['ageGroup'];
    _languagesSpoken = List<String>.from(widget.userSnapshot['languagesSpoken']);
    _preferredDestinations = List<String>.from(widget.userSnapshot['preferredDestinations']);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
        // Optionally, upload this image to Firebase Storage and save the URL in Firestore
      }
    });
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Users').doc(widget.userSnapshot.id).update({
          'full_name': _usernameController.text,
          'contact_details': _phoneNumberController.text,
          'email': _emailController.text,
          'importantNote': _importantNoteController.text,
          'preferredActivities': _preferredActivitiesController.text,
          'gender': _gender,
          'age_group': _ageGroup,
          'languagesSpoken': _languagesSpoken,
          'preferredDestinations': _preferredDestinations,
        });
        Navigator.pop(context); // Return to profile page after saving
      } catch (e) {
        print('Error saving profile: $e');
        // Handle error saving profile
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null && _profileImage!.path.isNotEmpty
                        ? FileImage(_profileImage!) as ImageProvider<Object>
                        : AssetImage('assets/profile_photo.png'),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Gender', style: TextStyle(fontSize: 18)),
              ListTile(
                title: const Text('Male'),
                leading: Radio<String>(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Female'),
                leading: Radio<String>(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Other'),
                leading: Radio<String>(
                  value: 'Other',
                  groupValue: _gender,
                  onChanged: (String? value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              Text('Age Group', style: TextStyle(fontSize: 18)),
              ListTile(
                title: const Text('18-25'),
                leading: Radio<String>(
                  value: '18-25',
                  groupValue: _ageGroup,
                  onChanged: (String? value) {
                    setState(() {
                      _ageGroup = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('26-35'),
                leading: Radio<String>(
                  value: '26-35',
                  groupValue: _ageGroup,
                  onChanged: (String? value) {
                    setState(() {
                      _ageGroup = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('36-45'),
                leading: Radio<String>(
                  value: '36-45',
                  groupValue: _ageGroup,
                  onChanged: (String? value) {
                    setState(() {
                      _ageGroup = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _importantNoteController,
                decoration: InputDecoration(labelText: 'Important Note'),
                maxLines: 3,
                validator: (value) {
                  // Add validation if needed
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _preferredActivitiesController,
                decoration: InputDecoration(labelText: 'Preferred Activities'),
                maxLines: 3,
                validator: (value) {
                  // Add validation if needed
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Languages Spoken', style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: _languagesSpoken
                    .map((language) => Chip(
                  label: Text(language),
                  onDeleted: () {
                    setState(() {
                      _languagesSpoken.remove(language);
                    });
                  },
                ))
                    .toList(),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add Language',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add functionality to add language
                    },
                  ),
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    _languagesSpoken.add(value);
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Preferred Destinations', style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: _preferredDestinations
                    .map((destination) => Chip(
                  label: Text(destination),
                  onDeleted: () {
                    setState(() {
                      _preferredDestinations.remove(destination);
                    });
                  },
                ))
                    .toList(),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add Destination',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add functionality to add destination
                    },
                  ),
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    _preferredDestinations.add(value);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
