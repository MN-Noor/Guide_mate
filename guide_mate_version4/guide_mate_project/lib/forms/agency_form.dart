import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_page.dart';

class AgencyFormPage extends StatefulWidget {
  final String email;

  const AgencyFormPage({Key? key, required this.email}) : super(key: key);

  @override
  _AgencyFormPageState createState() => _AgencyFormPageState();
}

class _AgencyFormPageState extends State<AgencyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _agencyNameController = TextEditingController();
  final TextEditingController _establishedYearController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _servicesProvidedController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _importantNoteController = TextEditingController();

  List<String> _selectedSpecialties = [];
  List<String> _servicesProvidedList = ['Luxury Tours', 'Budget Tours', 'Adventure Tours'];

  void _saveAgencyProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('agencies').doc(user.uid).set({
          'agency_name': _agencyNameController.text,
          'established_year': int.tryParse(_establishedYearController.text) ?? 0,
          'location': _locationController.text,
          'specialties': _selectedSpecialties,
          'services_provided': _servicesProvidedController.text,
          'phone_number': _phoneNumberController.text,
          'email': widget.email, // Use the passed email
          'website': _websiteController.text,
          'important_note': _importantNoteController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved successfully!')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: widget.email), // Pass email to HomePage
          ),
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
            onPressed: _saveAgencyProfile,
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
                controller: _agencyNameController,
                decoration: InputDecoration(labelText: 'Agency Name', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                validator: (value) => value!.isEmpty ? 'Please enter the agency name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _establishedYearController,
                decoration: InputDecoration(labelText: 'Established Year', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter the established year' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                validator: (value) => value!.isEmpty ? 'Please enter the location' : null,
              ),
              SizedBox(height: 10),
              Wrap(
                children: _servicesProvidedList.map((service) {
                  return CheckboxListTile(
                    title: Text(service),
                    value: _selectedSpecialties.contains(service),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            _selectedSpecialties.add(service);
                          } else {
                            _selectedSpecialties.remove(service);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _servicesProvidedController,
                decoration: InputDecoration(labelText: 'Other Services Provided', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
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
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Website (URL)', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _importantNoteController,
                decoration: InputDecoration(labelText: 'Any Important Note', filled: true, fillColor: Colors.teal.withOpacity(0.1)),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
