import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class InviteAFriend extends StatefulWidget {
  const InviteAFriend({super.key});

  @override
  State<InviteAFriend> createState() => _InviteAFriendState();
}

class _InviteAFriendState extends State<InviteAFriend> {
  String inviteLink = "www.Let's_chat_app.com"; // Replace with your actual invite link

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite a Friend"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invite a Friend",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Share the following link with your friend to invite them:",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Share the invite link when tapped

              },
              child: Text(
                inviteLink,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue, // Make the link look clickable
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Perform any additional action when the button is pressed
                // For example, you can open a share dialog or copy the link to clipboard
                Share.share(inviteLink);
              },
              child: Text("Share Invite Link"),
            ),
          ],
        ),
      ),
    );
  }
}
