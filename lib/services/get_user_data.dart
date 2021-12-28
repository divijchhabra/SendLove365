import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temp/screens/settings_screen.dart';
import 'package:temp/services/user_details.dart';

class GetUserData extends StatelessWidget {
  const GetUserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String documentId = uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    print(uid);
    print(users);
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          print('Error');

          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          print('Error');

          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          print('All ok');

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          UserDetails.name = data['userName'].toString();
          UserDetails.email = data['email'].toString();
          UserDetails.phone = data['phoneNo'].toString();
          UserDetails.uid = data['uid'];
          UserDetails.imageUrl = data['imageUrl'];

          return const SettingsScreen();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
