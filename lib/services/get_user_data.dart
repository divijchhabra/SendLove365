import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/services/get_images.dart';

class GetUserData extends StatelessWidget {
  const GetUserData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    String documentId = uid;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

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
          UserDetailsModel.name = data['userName'].toString();
          UserDetailsModel.email = data['email'].toString();
          UserDetailsModel.phone = data['phoneNo'].toString();
          UserDetailsModel.uid = data['uid'];
          UserDetailsModel.imageUrl = data['imageUrl'];

          return const GetImages();
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
