import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    phone = phone.substring(n - 10);

    userCollection
        .doc(uid)
        .set({
          "userName": userName,
          "email": email,
          "phoneNo": phone,
          "imageUrl": urlDownload,
          "uid": uid,
          "timeStamp": timeStamp,
        }, SetOptions(merge: true))
        .then((value) => print("User Details Added"))
        .catchError((error) => print("Failed to add user: $error"));

    return;
  }

  Future<void> storeUserFriends(List users) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection
        .doc(uid)
        .collection('friends')
        .doc()
        .set({'friends': users}, SetOptions(merge: true))
        .then((value) => null)
        .catchError((error) => {print('failed to add friends')});
  }

  Future<void> storeUserDetailsUpdated(
      userName, email, urlDownload, phoneNo) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    userCollection
        .doc(uid)
        .set({
          "userName": userName,
          "email": email,
          "phoneNo": phoneNo,
          "imageUrl": urlDownload,
          "uid": uid,
        }, SetOptions(merge: true))
        .then((value) => print("User Details Added"))
        .catchError((error) => print("Failed to add user: $error"));
    return;
  }
}
