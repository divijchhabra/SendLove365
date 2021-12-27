import 'package:flutter/material.dart';
import 'package:temp/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  children: const [
                    Text(
                      "Settings",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                  child: const CircleAvatar(
                    radius: 56,
                    backgroundImage: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAsK6oIKzeSCKiqpjv5cuoC4ZC_hJ0FxNkvQ&usqp=CAU'),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("John Mathew", style: kTextStyle),
                const SizedBox(height: 10),
                SizedBox(
                  height: 500,
                  child: ListView(
                    children: const [
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
                        title: Text("About Send Love"),
                      ),
                      Divider(),
                      ListTile(
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
    );
  }
}
