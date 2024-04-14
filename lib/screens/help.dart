
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to the Help Page!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "How can we assist you today?",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "1. If you are having trouble logging in, please visit the login page and ensure you are using the correct credentials.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "2. For any technical issues, you can contact our support team at support@letschat.com.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "3. Explore the features of our app by navigating through the different screens. If you have any questions, feel free to ask!",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            // Add more helpful information as needed
          ],
        ),
      ),
    );
  }
}
