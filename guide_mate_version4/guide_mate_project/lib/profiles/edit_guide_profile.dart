import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class EditGuideProfilePage extends StatefulWidget {
  final DocumentSnapshot userSnapshot;

  const EditGuideProfilePage({
    Key? key,
    required this.userSnapshot,
  }) : super(key: key);

  @override
  _EditGuideProfilePageState createState() => _EditGuideProfilePageState();
}

class _EditGuideProfilePageState extends State<EditGuideProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _importantNoteController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _languagesSpokenController;
  late TextEditingController _specialtyAreasController;
  late TextEditingController _availableDatesController;
  late TextEditingController _preferredMeetingLocationController;
  String? _selectedGender;
  File? _image;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userSnapshot['name']);
    _phoneNumberController = TextEditingController(text: widget.userSnapshot['contact_details']);
    _emailController = TextEditingController(text: widget.userSnapshot['email']);
    _importantNoteController = TextEditingController(text: widget.userSnapshot['importantNote']);
    _yearsOfExperienceController = TextEditingController(text: widget.userSnapshot['yearsOfExperience']);
    _languagesSpokenController = TextEditingController(text: widget.userSnapshot['languagesSpoken']);
    _specialtyAreasController = TextEditingController(text: widget.userSnapshot['specialityAreas']);
    _availableDatesController = TextEditingController(text: widget.userSnapshot['availableDates']);
    _preferredMeetingLocationController = TextEditingController(text: widget.userSnapshot['preferredMeetingLocation']);
    _selectedGender = widget.userSnapshot['gender'];
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('Users').doc(widget.userSnapshot.id).update({
          'name': _usernameController.text,
          'contact_details': _phoneNumberController.text,
          'email': _emailController.text,
          'importantNote': _importantNoteController.text,
          'yearsOfExperience': _yearsOfExperienceController.text,
          'languagesSpoken': _languagesSpokenController.text,
          'specialityAreas': _specialtyAreasController.text,
          'availableDates': _availableDatesController.text,
          'preferredMeetingLocation': _preferredMeetingLocationController.text,
          'gender': _selectedGender,
          'profilePhoto': _image?.path, // You might need to handle image upload to storage
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
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image == null
                        ? NetworkImage(widget.userSnapshot['profilePhoto'])
                        : FileImage(_image!) as ImageProvider,
                    child: Icon(
                      Icons.camera_alt,
                      size: 30,
                      color: Colors.white,
                    ),
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
                controller: _yearsOfExperienceController,
                decoration: InputDecoration(labelText: 'Years of Experience'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter years of experience';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _languagesSpokenController,
                decoration: InputDecoration(labelText: 'Languages Spoken'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter languages spoken';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _specialtyAreasController,
                decoration: InputDecoration(labelText: 'Specialty Areas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter specialty areas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _availableDatesController,
                decoration: InputDecoration(labelText: 'Available Dates'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _availableDatesController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter available dates';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _preferredMeetingLocationController,
                decoration: InputDecoration(labelText: 'Preferred Meeting Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter preferred meeting location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gender', style: TextStyle(fontSize: 16)),
                  RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
