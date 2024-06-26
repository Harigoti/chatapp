import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/api/apis.dart';
import 'package:chatapp/helper/time_formater.dart';
import 'package:chatapp/models/massage.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/user.dart';
import '../screens/chat_screen.dart';
import 'dialogs/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  final CUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      elevation: 1,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          _showPasswordDialog(context);
        },
        child: StreamBuilder(
          stream: APIs.getLastMassage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              message = list[0];
            }
            return ListTile(
              leading: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => ProfileDialog(user: widget.user));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                      imageUrl: widget.user.image,
                      width: mq.width * 0.15,
                      height: mq.width * 0.15,
                      errorWidget: (context, url, error) => const CircleAvatar(
                            child: Icon(Icons.person),
                          )),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                message != null
                    ? message!.type == 'text'
                        ? message!.msg
                        : 'Image'
                    : widget.user.about,
                maxLines: 1,
              ),
              trailing: message == null
                  ? null
                  : message!.read.isEmpty && message!.formid != APIs.user.uid
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.green,
                                child: null),
                          ],
                        )
                      : Text(MyDateUtil.getLastMessageTime(
                          context: context,
                          time: message!.send,
                          showYear: false)),
            );
          },
        ),
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    String password = '123';
    String enteredPassword = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            onChanged: (value) {
              enteredPassword = value;
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {

                // For now, let's just navigate to ChatScreen if password is not empty.
                if (enteredPassword.isNotEmpty) {
                  if (enteredPassword == password) {
                    Navigator.of(context).pop(); // Close the password dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(user: widget.user),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('incorrect password')),
                    );
                  }
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
