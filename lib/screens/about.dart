import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Developed by Engage Talk',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Contact us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Email: support@letschat.com',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Follow us on social media:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.facebook),
                  onPressed: () {
                    // Add the link to your Facebook page
                  },
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
