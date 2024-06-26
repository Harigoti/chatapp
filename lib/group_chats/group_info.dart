import 'package:chatapp/group_chats/group_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatapp/group_chats/add_members.dart';
import 'package:chatapp/Screens/home_screen.dart';

class GroupInfo extends StatefulWidget {
  final String groupId, groupName;
  const GroupInfo({required this.groupId, required this.groupName, Key? key})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  List membersList = [];
  bool isLoading = true;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getGroupDetails();
  }

  Future getGroupDetails() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((chatMap) {
      membersList = chatMap['members'];
      print(membersList);
      isLoading = false;
      setState(() {});
    });
  }

  bool checkAdmin() {
    bool isAdmin = false;

    for (var element in membersList) {
      if (element['id'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'] ?? false;
        break;
      }
    }

    return isAdmin;
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future removeMembers(int index) async {
    String uid = membersList[index]['id'];

    setState(() {
      isLoading = true;
      membersList.removeAt(index);
    });

    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    }).then((value) async {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      setState(() {
        isLoading = false;
      });

      showToast("Successfully removed");

      Navigator.of(context).pop();
    });
  }

  void showDialogBox(int index) {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != membersList[index]['id']) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: ListTile(
                  onTap: () => removeMembers(index),
                  title: Text("Remove This Member"),
                ),
              );
            });
      }
    }
  }

  Future onLeaveGroup() async {
    setState(() {
      isLoading = true;
    });

    // Remove the current user from the members list
    membersList.removeWhere((member) => member['id'] == _auth.currentUser!.uid);

    // Update the group's members list in Firestore
    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    });

    // Remove the group from the user's list of groups
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('groups')
        .doc(widget.groupId)
        .delete();

    // Navigate back to the HomeScreen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => HomeScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Container(
          height: size.height,
          width: size.width,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              Container(
                height: size.height / 8,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Container(
                      height: size.height / 11,
                      width: size.height / 11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: Icon(
                        Icons.group,
                        color: Colors.white,
                        size: size.width / 10,
                      ),
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          widget.groupName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: size.width / 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              Container(
                width: size.width / 1.1,
                child: Text(
                  "${membersList.length} Members",
                  style: TextStyle(
                    fontSize: size.width / 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 20,
              ),
              checkAdmin()
                  ? ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddMembersINGroup(
                      groupChatId: widget.groupId,
                      name: widget.groupName,
                      membersList: membersList,
                    ),
                  ),
                ),
                leading: Icon(
                  Icons.add,
                ),
                title: Text(
                  "Add Members",
                  style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  : SizedBox(),
              Flexible(
                child: ListView.builder(
                  itemCount: membersList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => showDialogBox(index),
                      leading: Icon(Icons.account_circle),
                      title: Text(
                        membersList[index]['name'],
                        style: TextStyle(
                          fontSize: size.width / 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(membersList[index]['email']),
                      trailing: Text(
                          membersList[index]['isAdmin'] ? "Admin" : ""),
                    );
                  },
                ),
              ),
              ListTile(
                onTap: onLeaveGroup,
                leading: Icon(
                  Icons.logout,
                  color: Colors.redAccent,
                ),
                title: Text(
                  "Leave Group",
                  style: TextStyle(
                    fontSize: size.width / 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
