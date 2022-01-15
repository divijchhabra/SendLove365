import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class StoreUserInfo {
  //getUserDetails
  Future<void> storeUserDetails(
      userName, email, urlDownload, phoneNo, timeStamp) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    String phone = phoneNo.toString();
    int n = phone.length;
    phone = phone.substring(n - kCountryNumberLength);

    userCollection.doc(uid).set({
      "userName": userName,
      "email": email,
      "phoneNo": phone,
      "imageUrl": urlDownload,
      "uid": uid,
      "timeStamp": timeStamp,
    }, SetOptions(merge: true)).then((value) {
      print("User Details Added");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
    return;
  }

  Future<void> updateUserDetails(urlDownload, name) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection.doc(uid).update({
      "imageUrl": urlDownload,
      "userName": name,
    }).then((value) {
      print("User Details Added");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
    return;
  }
}
