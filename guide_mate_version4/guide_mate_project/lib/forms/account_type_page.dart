import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'guide_form.dart';
import 'tourist_form.dart';
import 'agency_form.dart';

class AccountTypeSelectionPage extends StatefulWidget {
  final String email;

  AccountTypeSelectionPage({required this.email});

  @override
  _AccountTypeSelectionPageState createState() =>
      _AccountTypeSelectionPageState();
}

class _AccountTypeSelectionPageState extends State<AccountTypeSelectionPage> {
  String _selectedAccountType = 'Select Account Type'; // Default value
  final List<String> _accountTypes = [
    'Select Account Type',
    'Tourist',
    'Guide',
    'Travel Agency'
  ];

  void _selectAccountType(String? accountType) {
    if (accountType != null) {
      setState(() {
        _selectedAccountType = accountType;
      });
    }
  }

  Future<void> _saveAccountType() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.email)
          .set({'email': widget.email, 'user_type': _selectedAccountType});
    } catch (e) {
      print("Error saving account type: $e");
    }
  }

  void _navigateToProfileForm() async {
    await _saveAccountType();

    if (_selectedAccountType == 'Tourist') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TouristFormPage(email: widget.email)),
      );
    } else if (_selectedAccountType == 'Guide') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GuideFormPage(email: widget.email)),
      );
    } else if (_selectedAccountType == 'Travel Agency') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AgencyFormPage(email: widget.email)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Account Type"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300,
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: _selectedAccountType,
                    onChanged: _selectAccountType,
                    items: _accountTypes.map((String accountType) {
                      return DropdownMenuItem<String>(
                        value: accountType,
                        child: Text(accountType),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _navigateToProfileForm,
                    child: Text('Continue'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'guide_form.dart';
// import 'tourist_form.dart';
// import 'agency_form.dart';
//
// class AccountTypeSelectionPage extends StatefulWidget {
//   final String email;
//
//   AccountTypeSelectionPage({required this.email});
//
//   @override
//   _AccountTypeSelectionPageState createState() =>
//       _AccountTypeSelectionPageState();
// }
//
// class _AccountTypeSelectionPageState extends State<AccountTypeSelectionPage> {
//   String _selectedAccountType = 'Select Account Type'; // Default value
//   final List<String> _accountTypes = [
//     'Select Account Type',
//     'Tourist',
//     'Guide',
//     'Travel Agency'
//   ];
//
//   void _selectAccountType(String? accountType) {
//     if (accountType != null) {
//       setState(() {
//         _selectedAccountType = accountType;
//       });
//     }
//   }
//
//   Future<void> _saveAccountType() async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.email)
//           .set({'email': widget.email, 'user_type': _selectedAccountType});
//     } catch (e) {
//       print("Error saving account type: $e");
//     }
//   }
//
//   void _navigateToProfileForm() async {
//     await _saveAccountType();
//
//     if (_selectedAccountType == 'Tourist') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => TouristFormPage(email: widget.email)),
//       );
//     } else if (_selectedAccountType == 'Guide') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => GuideFormPage(email: widget.email)),
//       );
//     } else if (_selectedAccountType == 'Travel Agency') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => AgencyFormPage(email: widget.email)),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Select Account Type"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButton<String>(
//               value: _selectedAccountType,
//               onChanged: _selectAccountType,
//               items: _accountTypes.map((String accountType) {
//                 return DropdownMenuItem<String>(
//                   value: accountType,
//                   child: Text(accountType),
//                 );
//               }).toList(),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _navigateToProfileForm,
//               child: Text('Continue'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 backgroundColor: Colors.teal,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
