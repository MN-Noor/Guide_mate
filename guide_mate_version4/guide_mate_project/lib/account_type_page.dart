// import 'package:flutter/material.dart';
// import 'package:guide_mate_project/fire_auth/signup_page.dart';
// import 'package:guide_mate_project/guide_signup_form.dart';
//
// class AccountTypeSelectionPage extends StatefulWidget {
//   final String email;
//
//   const AccountTypeSelectionPage({Key? key, required this.email}) : super(key: key);
//
//   @override
//   _AccountTypeSelectionPageState createState() => _AccountTypeSelectionPageState();
// }
//
// class _AccountTypeSelectionPageState extends State<AccountTypeSelectionPage> {
//   String _selectedAccountType = 'Select Account Type'; // Default value
//   final List<String> _accountTypes = [
//     'Select Account Type',
//     'Tourist',
//     'Guide'
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
//   void _navigateToSignup() {
//     Navigator.pop(context); // Close the dialog
//     if (_selectedAccountType == 'Tourist') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SignupPage(email: widget.email)), // Pass email
//       );
//     } else if (_selectedAccountType == 'Guide') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SignUpFormPage(email: widget.email)), // Pass email
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           DropdownButton<String>(
//             value: _selectedAccountType,
//             onChanged: _selectAccountType,
//             items: _accountTypes.map((String accountType) {
//               return DropdownMenuItem<String>(
//                 value: accountType,
//                 child: Text(accountType),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: _selectedAccountType != 'Select Account Type'
//                 ? _navigateToSignup
//                 : null,
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white,
//               backgroundColor: Colors.teal,
//             ),
//             child: const Text('Sign Up'),
//           ),
//         ],
//       ),
//     );
//   }
// }
