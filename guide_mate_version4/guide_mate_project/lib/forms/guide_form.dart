import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_page.dart';

class GuideFormPage extends StatefulWidget {
  final String email;

  const GuideFormPage({Key? key, required this.email}) : super(key: key);

  @override
  _GuideFormPageState createState() => _GuideFormPageState();
}

class _GuideFormPageState extends State<GuideFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _permanentAddressController = TextEditingController();
  final TextEditingController _postalAddressController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _importantNoteController = TextEditingController();

  String? _selectedGender;
  String? _selectedAgeGroup;
  List<String> _selectedSpecialityAreas = [];
  List<String> _selectedMeetingLocations = [];
  List<DateTime> _selectedAvailableDates = [];
  List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese'];
  List<String> _selectedLanguages = [];

  void _saveGuideProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('guides').doc(user.uid).set({
          'full_name': _fullNameController.text,
          'age_group': _selectedAgeGroup,
          'gender': _selectedGender,
          'cnic': _cnicController.text,
          'permanent_address': _permanentAddressController.text,
          'postal_address': _postalAddressController.text,
          'languages_spoken': _selectedLanguages,
          'experience': int.tryParse(_experienceController.text) ?? 0,
          'speciality_areas': _selectedSpecialityAreas,
          'available_dates': _selectedAvailableDates.map((e) => e.toIso8601String()).toList(),
          'preferred_meeting_locations': _selectedMeetingLocations,
          'phone_number': _phoneNumberController.text,
          'email': widget.email, // Use the passed email
          'important_note': _importantNoteController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved successfully!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: widget.email), // Pass the email to HomePage
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && !_selectedAvailableDates.contains(picked)) {
      setState(() {
        _selectedAvailableDates.add(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Your Profile'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveGuideProfile,
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
                controller: _cnicController,
                decoration: InputDecoration(labelText: 'CNIC Number', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter your CNIC number' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _permanentAddressController,
                decoration: InputDecoration(labelText: 'Permanent Address', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? 'Please enter your permanent address' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _postalAddressController,
                decoration: InputDecoration(labelText: 'Postal Address', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                maxLines: 2,
                validator: (value) => value!.isEmpty ? 'Please enter your postal address' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(labelText: 'Years of Experience', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter your years of experience' : null,
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
                controller: _languagesController,
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
              Text('Specialty Areas', style: TextStyle(fontSize: 16)),
              CheckboxListTile(
                title: Text('Historical Sites'),
                value: _selectedSpecialityAreas.contains('Historical Sites'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedSpecialityAreas.add('Historical Sites');
                    } else {
                      _selectedSpecialityAreas.remove('Historical Sites');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Adventure Trips'),
                value: _selectedSpecialityAreas.contains('Adventure Trips'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedSpecialityAreas.add('Adventure Trips');
                    } else {
                      _selectedSpecialityAreas.remove('Adventure Trips');
                    }
                  });
                },
              ),
              SizedBox(height: 10),
              Text('Available Dates', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 6.0,
                children: _selectedAvailableDates.map((date) {
                  return Chip(
                    label: Text('${date.day}/${date.month}/${date.year}'),
                    onDeleted: () {
                      setState(() {
                        _selectedAvailableDates.remove(date);
                      });
                    },
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Dates'),
              ),
              SizedBox(height: 10),
              Text('Preferred Meeting Locations', style: TextStyle(fontSize: 16)),
              CheckboxListTile(
                title: Text('Central Area'),
                value: _selectedMeetingLocations.contains('Central Area'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedMeetingLocations.add('Central Area');
                    } else {
                      _selectedMeetingLocations.remove('Central Area');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Suburbs'),
                value: _selectedMeetingLocations.contains('Suburbs'),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedMeetingLocations.add('Suburbs');
                    } else {
                      _selectedMeetingLocations.remove('Suburbs');
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
