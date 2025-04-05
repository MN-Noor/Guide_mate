//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../forms/account_type_page.dart';
// import '../home_page.dart'; 
// import '../fire_auth/auth_service.dart';
// import 'signup_page.dart';
//
// class LoginPage extends StatefulWidget {
//
//   const LoginPage({Key? key}) : super(key: key);
//
//
//
//
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final AuthService _authService = AuthService();
//
//   String? _errorMessage;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Container(
//           margin: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _header(context),
//               _inputField(context),
//               _signup(context),
//               if (_errorMessage != null)
//                 Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _header(BuildContext context) {
//     return const Column(
//       children: [
//         Text(
//           "Welcome Back",
//           style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//         ),
//         Text("Enter your credentials to login"),
//       ],
//     );
//   }
//
//   Widget _inputField(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         TextField(
//           controller: _emailController,
//           decoration: InputDecoration(
//             hintText: "Email",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(18),
//               borderSide: BorderSide.none,
//             ),
//             fillColor: Colors.teal.withOpacity(0.1),
//             filled: true,
//             prefixIcon: const Icon(Icons.email),
//           ),
//         ),
//         const SizedBox(height: 10),
//         TextField(
//           controller: _passwordController,
//           decoration: InputDecoration(
//             hintText: "Password",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(18),
//               borderSide: BorderSide.none,
//             ),
//             fillColor: Colors.teal.withOpacity(0.1),
//             filled: true,
//             prefixIcon: const Icon(Icons.password),
//           ),
//           obscureText: true,
//         ),
//         const SizedBox(height: 10),
//         ElevatedButton(
//           onPressed: () async {
//             await _handleLogin(context);
//           },
//           style: ElevatedButton.styleFrom(
//             shape: const StadiumBorder(),
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             backgroundColor: Colors.teal,
//           ),
//           child: const Text(
//             "Login",
//             style: TextStyle(fontSize: 20, color: Colors.white),
//           ),
//         )
//       ],
//     );
//   }
//
//   Future<void> _handleLogin(BuildContext context) async {
//     String email = _emailController.text;
//     String password = _passwordController.text;
//
//     try {
//       User? user =
//       await _authService.loginUserWithEmailAndPassword(email, password);
//
//       if (user != null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(email: email), 
//           ),
//         );
//       } else {
//         setState(() {
//           _errorMessage =
//           'Login failed. Please check your credentials and try again.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Login failed. ${e.toString()}';
//       });
//     }
//   }
//
//   Widget _signup(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text("Don't have an account? "),
//         TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SignupPage(),),
//             );
//           },
//           child: const Text(
//             "Sign Up",
//             style: TextStyle(color: Colors.teal),
//           ),
//         ),
//       ],
//     );
//   }
// }
//


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../forms/account_type_page.dart';
import '../home_page.dart'; // Adjust the import path as per your project structure
import '../fire_auth/auth_service.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _signup(context),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.teal.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.teal.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            await _handleLogin(context);
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.teal,
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      User? user =
      await _authService.loginUserWithEmailAndPassword(email, password);

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: email), 
          ),
        );
      } else {
        setState(() {
          _errorMessage =
          'Login failed. Please check your credentials and try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed. ${e.toString()}';
      });
    }
  }

  Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupPage(),),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.teal),
          ),
        ),
      ],
    );
  }
}
