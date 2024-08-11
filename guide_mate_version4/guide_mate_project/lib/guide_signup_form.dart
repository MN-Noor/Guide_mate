import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpFormPage extends StatefulWidget {
  const SignUpFormPage({super.key});

  @override
  _SignUpFormPageState createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<SignUpFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _contactDetails = '';
  String _expertise = '';
  String _servicesOffered = '';
  String _officialId = '';
  String _address = '';
  String _postalAddress = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String? _certifications;
  bool _agreeToTerms = false;

  void _submitForm() {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      // Perform document authenticity checks here
      // If successful, proceed to set security preferences
      _setSecurityPreferences();
    }
  }

  void _setSecurityPreferences() {
    // Set security preferences here
    // After setting preferences, confirm profile creation
    _confirmProfileCreation();
  }

  void _confirmProfileCreation() {
    // Save profile to the database here
    // Show confirmation message to the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Profile Created'),
          content: const Text('Your profile has been successfully created.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to home or login page
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsAndConditions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsAndConditionsPage()),
    );
  }

  void _pickFile() async {
    // Implement file picking logic here
    // For example, using file_picker package
    // FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    // if (result != null) {
    //   PlatformFile file = result.files.first;
    //   setState(() {
    //     _certifications = file.name;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(' '),
        ),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _header(context),
                  _inputFields(context),
                  _termsAndConditions(context),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _header(context) {
    return const Column(
      children: [
        Text(
          "Create Your Profile",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text("Enter your details to sign up"),
      ],
    );
  }

  _inputFields(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _textField("First Name", Icons.person, (value) {
          _firstName = value;
        }, [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))]),
        const SizedBox(height: 10),
        _textField("Last Name", Icons.person, (value) {
          _lastName = value;
        }, [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))]),
        const SizedBox(height: 10),
        _textField("Contact Details", Icons.contact_phone, (value) {
          _contactDetails = value;
        }, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)]),
        const SizedBox(height: 10),
        _textField("Expertise", Icons.work, (value) {
          _expertise = value;
        }, [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z, ]"))]),
        const SizedBox(height: 10),
        _textField("Services Offered", Icons.list, (value) {
          _servicesOffered = value;
        }),
        const SizedBox(height: 10),
        _textField("Address", Icons.location_city, (value) {
          _address = value;
        }),
        const SizedBox(height: 10),
        _textField("Postal Address", Icons.mail, (value) {
          _postalAddress = value;
        }),
        const SizedBox(height: 10),
        _textField("Email", Icons.email, (value) {
          _email = value;
        }, [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]+"))]),
        const SizedBox(height: 10),
        _passwordField("Password", (value) {
          _password = value;
        }),
        const SizedBox(height: 10),
        _passwordField("Confirm Password", (value) {
          _confirmPassword = value;
        }),
        const SizedBox(height: 10),
        _textField("Official ID (CNIC)", Icons.credit_card, (value) {
          _officialId = value;
        }, [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(13)]),
        const SizedBox(height: 10),
        _filePickerField("Certifications (PDF)", () {
          _pickFile();
        }),
      ],
    );
  }

  _textField(String hintText, IconData icon, Function(String) onChanged,
      [List<TextInputFormatter>? inputFormatters]) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.teal.withOpacity(0.1),
        filled: true,
        prefixIcon: Icon(icon),
      ),
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        return null;
      },
    );
  }

  _passwordField(String hintText, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.teal.withOpacity(0.1),
        filled: true,
        prefixIcon: const Icon(Icons.lock),
      ),
      obscureText: true,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        return null;
      },
    );
  }

  _filePickerField(String hintText, VoidCallback onPressed) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.teal.withOpacity(0.1),
        filled: true,
        prefixIcon: const Icon(Icons.file_upload),
        suffixIcon: IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: onPressed,
        ),
      ),
      readOnly: true,
      controller: TextEditingController(text: _certifications),
      validator: (value) {
        if (value != null && value.isNotEmpty && !value.endsWith('.pdf')) {
          return 'Please upload a valid PDF file';
        }
        return null;
      },
    );
  }

  _termsAndConditions(context) {
    return Row(
      children: [
        Checkbox(
          value: _agreeToTerms,
          onChanged: (value) {
            setState(() {
              _agreeToTerms = value!;
            });
          },
        ),
        const Text("I agree to the "),
        GestureDetector(
          onTap: _showTermsAndConditions,
          child: const Text(
            "terms and conditions",
            style: TextStyle(color: Colors.teal, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }

  _submitButton(context) {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.teal,
      ),
      child: const Text(
        "Register",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Here are the terms and conditions. Please read them carefully. '
              'If any information provided is found to be false or if any mishap occurs, '
              'the user will be held responsible.',
        ),
      ),
    );
  }
}
