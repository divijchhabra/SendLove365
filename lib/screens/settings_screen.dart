// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/phoneno_screen.dart';
import 'package:temp/models/user_details_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/Send LOve Icon envelope.png',
                        height: 68,
                        width: 68,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Settings",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage:
                          NetworkImage(UserDetailsModel.imageUrl.toString()),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(UserDetailsModel.name.toString(), style: kTextStyle),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 500,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          title: Text("Profile"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.headphones,
                            color: kPrimaryColor,
                          ),
                          title: Text("Contact Us"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: kPrimaryColor,
                          ),
                          title: Text("About Likeu"),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () async {
                            await logOut();
                          },
                          leading: Icon(
                            Icons.logout,
                            color: kPrimaryColor,
                          ),
                          title: Text("Log Out"),
                        ),
                      ],
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

  Future<void> logOut() async {
    setState(() {
      showSpinner = true;
    });
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        FirebaseAuth.instance.signOut().then((value) => {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => PhoneNo(),
                ),
              )
            });
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      Fluttertoast();
    }
  }
}
