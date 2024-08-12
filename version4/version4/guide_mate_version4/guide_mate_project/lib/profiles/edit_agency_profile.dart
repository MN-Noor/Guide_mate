import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditAgencyProfilePage extends StatefulWidget {
  final DocumentSnapshot agencySnapshot;

  const EditAgencyProfilePage({
    Key? key,
    required this.agencySnapshot,
  }) : super(key: key);

  @override
  _EditAgencyProfilePageState createState() => _EditAgencyProfilePageState();
}

class _EditAgencyProfilePageState extends State<EditAgencyProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _agencyNameController;
  late TextEditingController _establishedYearController;
  late TextEditingController _locationController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _importantNoteController;
  List<String> _selectedSpecialties = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    _agencyNameController = TextEditingController(text: widget.agencySnapshot['name']);
    _establishedYearController = TextEditingController(text: widget.agencySnapshot['establishedYear']);
    _locationController = TextEditingController(text: widget.agencySnapshot['location']);
    _phoneNumberController = TextEditingController(text: widget.agencySnapshot['phoneNumber']);
    _emailController = TextEditingController(text: widget.agencySnapshot['email']);
    _websiteController = TextEditingController(text: widget.agencySnapshot['website']);
    _importantNoteController = TextEditingController(text: widget.agencySnapshot['importantNote']);
    _selectedSpecialties = List<String>.from(widget.agencySnapshot['specialties']);
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
        await FirebaseFirestore.instance.collection('Agencies').doc(widget.agencySnapshot.id).update({
          'name': _agencyNameController.text,
          'establishedYear': _establishedYearController.text,
          'location': _locationController.text,
          'phoneNumber': _phoneNumberController.text,
          'email': _emailController.text,
          'website': _websiteController.text,
          'importantNote': _importantNoteController.text,
          'specialties': _selectedSpecialties,
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
        title: Text('Edit Agency Profile'),
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
                        ? NetworkImage(widget.agencySnapshot['profilePhoto'])
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
                controller: _agencyNameController,
                decoration: InputDecoration(labelText: 'Agency Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter agency name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _establishedYearController,
                decoration: InputDecoration(labelText: 'Established Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter established year';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Specialties', style: TextStyle(fontSize: 16)),
                  CheckboxListTile(
                    title: const Text('Luxury Tours'),
                    value: _selectedSpecialties.contains('Luxury Tours'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSpecialties.add('Luxury Tours');
                        } else {
                          _selectedSpecialties.remove('Luxury Tours');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Budget Tours'),
                    value: _selectedSpecialties.contains('Budget Tours'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSpecialties.add('Budget Tours');
                        } else {
                          _selectedSpecialties.remove('Budget Tours');
                        }
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Adventure Tours'),
                    value: _selectedSpecialties.contains('Adventure Tours'),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSpecialties.add('Adventure Tours');
                        } else {
                          _selectedSpecialties.remove('Adventure Tours');
                        }
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
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
                    return 'Please enter email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Website'),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter website';
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter important note';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
