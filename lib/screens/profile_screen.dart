import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final CUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // AppBar
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.05,
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          File(_image!),
                          width: mq.width * 0.3,
                          height: mq.width * 0.3,
                          fit: BoxFit.cover,
                        ),
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                            imageUrl: widget.user.image,
                            width: mq.width * 0.3,
                            height: mq.width * 0.3,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                            const CircleAvatar(
                              child: Icon(Icons.person),
                            )),
                      ),
                      Positioned(
                        bottom: -6,
                        right: -26,
                        child: MaterialButton(
                          onPressed: () {
                            _showBottomSheet();
                          },
                          shape: const CircleBorder(),
                          color: Colors.lightBlueAccent,
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.02,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                        fontSize: 18),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.05,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (value) => APIs.me.name = value ?? '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                      focusColor: Colors.blue,
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.blueAccent),
                      hintText: 'Enter your name',
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.02,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (value) => APIs.me.about = value ?? '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter about';
                      }
                      return null;
                    },
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                      focusColor: Colors.blue,
                      labelText: 'About',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10),),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      prefixIcon: Icon(Icons.info_outline,color: Colors.blueAccent),
                      hintText: "Enter your about",
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * 0.05,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {
                          Dialogs.showProgressBar(context);
                          APIs.updateInfo().then((value) {
                            Navigator.pop(context);
                            _showToast("Profile updated successfully");
                          });
                        });
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('UPDATE',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      minimumSize: Size(mq.width * 0.2, mq.height * 0.06),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20, bottom: 65),
            children: [
              const Center(
                child: Text(
                  'Choose Image',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      log(" image path ${image.path}");
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateImage(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.lightBlueAccent,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * 0.4, mq.height * 0.1),
                  ),
                  child: const Icon(
                    Icons.camera,
                    color: Colors.white,

                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 50,
                    );
                    if (image != null) {
                      log(" image path ${image.path}");
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateImage(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.lightBlueAccent,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * 0.4, mq.height * 0.1),
                  ),
                  child: const Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                ),
              ]),
            ],
          );
        });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}
