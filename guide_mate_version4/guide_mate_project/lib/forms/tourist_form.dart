import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_page.dart';

class TouristFormPage extends StatefulWidget {
  final String email;

  const TouristFormPage({Key? key, required this.email}) : super(key: key);

  @override
  _TouristFormPageState createState() => _TouristFormPageState();
}

class _TouristFormPageState extends State<TouristFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _importantNoteController = TextEditingController();

  String? _selectedGender;
  String? _selectedAgeGroup;
  List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
  List<String> _selectedLanguages = [];
  List<String> _selectedDestinations = [];
  List<String> _selectedActivities = [];

  void _saveTouristProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('tourists').doc(user.uid).set({
          'full_name': _fullNameController.text,
          'age_group': _selectedAgeGroup,
          'gender': _selectedGender,
          'languages_spoken': _selectedLanguages,
          'preferred_destinations': _selectedDestinations,
          'preferred_activities': _selectedActivities,
          'phone_number': _phoneNumberController.text,
          'email': widget.email, // Use the passed email
          'important_note': _importantNoteController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved successfully!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(email: widget.email)), // Pass the email to HomePage
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Build Your Profile'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTouristProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
              ),
              SizedBox(height: 10),
              Text('Age Group', style: TextStyle(fontSize: 16)),
              Row(
                children: ['18-25', '26-35', '36 and above'].map((ageGroup) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(ageGroup),
                      value: ageGroup,
                      groupValue: _selectedAgeGroup,
                      onChanged: (value) {
                        setState(() {
                          _selectedAgeGroup = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text('Gender', style: TextStyle(fontSize: 16)),
              Row(
                children: ['Male', 'Female', 'Other'].map((gender) {
                  return Expanded(
                    child: RadioListTile<String>(
                      title: Text(gender),
                      value: gender,
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _importantNoteController,
                decoration: InputDecoration(labelText: 'Any Important Note', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _selectedLanguages.isNotEmpty ? TextEditingController(text: _selectedLanguages.join(', ')) : TextEditingController(),
                decoration: InputDecoration(labelText: 'Languages Spoken', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguages = _languages
                        .where((language) => language.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
              ),
              Wrap(
                spacing: 6.0,
                children: _selectedLanguages.map((language) {
                  return Chip(
                    label: Text(language),
                    onDeleted: () {
                      setState(() {
                        _selectedLanguages.remove(language);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              Text('Preferred Destinations', style: TextStyle(fontSize: 16)),
              CheckboxListTile(
                title: Text('Beach'),
                value: _selectedDestinations.contains('Beach'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedDestinations.add('Beach');
                    } else {
                      _selectedDestinations.remove('Beach');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Mountain'),
                value: _selectedDestinations.contains('Mountain'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedDestinations.add('Mountain');
                    } else {
                      _selectedDestinations.remove('Mountain');
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              Text('Preferred Activities', style: TextStyle(fontSize: 16)),
              CheckboxListTile(
                title: Text('Sightseeing'),
                value: _selectedActivities.contains('Sightseeing'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedActivities.add('Sightseeing');
                    } else {
                      _selectedActivities.remove('Sightseeing');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Adventure Sports'),
                value: _selectedActivities.contains('Adventure Sports'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedActivities.add('Adventure Sports');
                    } else {
                      _selectedActivities.remove('Adventure Sports');
                    }
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
