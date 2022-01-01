import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StoreMessages {
  //getUserDetails
  Future<void> storeUserDetails(avatar, time, message, phoneNo) async {
    final CollectionReference messageCollection =
        FirebaseFirestore.instance.collection('messages');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();

    messageCollection
        .doc(uid)
        .set({
          phoneNo.toString(): {
            "avatar": avatar,
            "time": time,
            "message": message,
            "phone": phoneNo,
          },
        }, SetOptions(merge: true))
        .then((value) => print("User Details Added"))
        .catchError((error) => print("Failed to add user: $error"));

    return;
  }

// Update details
// Future<void> storeUserDetailsUpdated(
//     email, name, phone, location, insta_id, job_title, isAdmin) async {
//   final CollectionReference userCollection =
//       FirebaseFirestore.instance.collection('Users');
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String uid = auth.currentUser!.uid.toString();
//
//   userCollection
//       .doc(uid)
//       .set({
//         "Info": {
//           "Name": name,
//           "Email": email,
//           "PhoneNumber": phone,
//           "Uid": uid,
//           "IsAdmin": isAdmin,
//           "Location": location,
//           "InstaId": insta_id,
//           "JobTitle": job_title,
//         },
//       }, SetOptions(merge: true))
//       .then((value) => print("User Details Added"))
//       .catchError((error) => print("Failed to add user: $error"));
//   return;
// }
}
