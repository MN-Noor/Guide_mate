import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class GeminiResponsePage extends StatelessWidget {
  final String response;

  const GeminiResponsePage({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Plan Response'),
      ),
      body: Container(
        color: Colors.teal,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Image.asset(
                    'assets/images/tripPlan.jpg', // Replace with your image path
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: MarkdownBody(
                    data: response,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(
                        color: Colors.teal, // Set text color to teal
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
