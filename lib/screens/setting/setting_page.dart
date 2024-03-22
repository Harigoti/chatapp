import 'package:chatapp/screens/about.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../api/apis.dart';
import '../../helper/dialogs.dart';
import '../../models/user.dart';
import '../auth/login_screen.dart';
import '../invite_a_friend.dart';
import '../src/babs_component_settings_group.dart';
import '../src/babs_component_settings_item.dart';
import '../src/babs_component_simple_user_card.dart';
import '../src/icon_style.dart';

class SettingPage extends StatefulWidget {
  final CUser user;
  const SettingPage({super.key, required this.user});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.80),
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // user card
            SimpleUserCard(
              imageRadius: 100,
              userName: widget.user.name,
              userProfilePic: NetworkImage(widget.user.image),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfileScreen(user: APIs.me)));
              },
            ),
            SettingsGroup(
              items: [

                SettingsItem(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const InviteAFriend()));
                  },
                  icons: CupertinoIcons.t_bubble,
                  iconStyle: IconStyle(),
                  title: 'Tell a friend ',
                  subtitle: "Invite Friend to App",
                  titleMaxLine: 1,
                  subtitleMaxLine: 1,
                ),

              ],
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AboutScreen()));},
                  icons: Icons.info_outline_rounded,
                  iconStyle: IconStyle(
                    backgroundColor: Colors.purple,
                  ),
                  title: 'About',
                  subtitle: "Learn more about Chat App",
                ),
              ],
            ),
            // You can add a settings title
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () async {
                    await APIs.updateActiveStatus(false);
                    Dialogs.showProgressBar(context);
                    await APIs.auth.signOut().then((value) async {
                      await GoogleSignIn().signOut().then((value) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        APIs.auth = FirebaseAuth.instance;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()));
                      });
                    });
                  },
                  icons: Icons.exit_to_app_rounded,
                  title: "Sign Out",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
