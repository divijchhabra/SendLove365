// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/screens/chat/chat.dart';
import 'package:temp/screens/invite_friend.dart';
import '../invite_friends_screen.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<String> myFriends = [];
  List<Contact> contacts = [];

  Future<void> getContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts.toSet().toList();
    });
  }

  String currentUserId = UserDetailsModel.phone.toString();
  dynamic chatDocId;

  Future<void> checkPermissionPhoneLogs() async {
    setState(() {
      showSpinner = true;
    });
    if (Platform.isIOS
        ? await Permission.contacts.request().isGranted
        : await Permission.phone.request().isGranted &&
            await Permission.contacts.request().isGranted) {
      await getContacts();

      setState(() {
        showSpinner = false;
      });
      // print('Hello ${contacts.length}');
    } else {
      setState(() {
        showSpinner = false;
      });
      if (Platform.isIOS) {
        await Permission.contacts.request();
      } else {
        await Permission.phone.request();
        await Permission.contacts.request();
      }

      Fluttertoast.showToast(
        msg: 'Provide Phone permission to make a call and view logs.',
      );
    }
  }

  List firebaseUserPhone = [];
  List firebaseUserDp = [];
  bool isMessage = true;

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  Future<void> checkUser(friendPhoneUid) async {
    await chats
        .where('users', isEqualTo: {friendPhoneUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            // print(querySnapshot.docs.isEmpty);
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              // print('value $chatDocId');
            }
          },
        )
        .catchError((error) {
          Fluttertoast.showToast(msg: error.toString());
          // print('bad $error');
        });
  }

  String lastMsg = 'kkkk';

  Future<String> getLastMessage(friendPhoneUid) async {
    await chats
        .where('users', isEqualTo: {friendPhoneUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            // print(querySnapshot.docs.isEmpty);
            if (querySnapshot.docs.isNotEmpty) {
              chatDocId = querySnapshot.docs.single.id;

              // print('value $chatDocId');
            }
          },
        )
        .catchError((error) {
          Fluttertoast.showToast(msg: error.toString());
          // print('bad $error');
        });

    await chats
        .doc(chatDocId)
        .collection('messages')
        .orderBy('createdOn', descending: true)
        .get()
        .then((QuerySnapshot snapshot) {
      print(snapshot.docs[0]['message'].toString());
      lastMsg = snapshot.docs[0]['message'].toString();
      isMessage = snapshot.docs[0]['isMsg'];
      return snapshot.docs[0]['message'].toString();
    });
    return isMessage ? lastMsg : 'Photo';
  }

  String dpS = '';

  Future<String> getDp(number) async {
    CollectionReference dp = FirebaseFirestore.instance.collection('users');
    await dp
        .where('phoneNo', isEqualTo: number)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      print(querySnapshot.docs[0]['imageUrl'].toString());
      dpS = querySnapshot.docs[0]['imageUrl'].toString();
      return querySnapshot.docs[0]['imageUrl'].toString();
    });
    return dpS;
  }

  @override
  void initState() {
    super.initState();
    checkPermissionPhoneLogs();

    // getDp('8329763258');
    firebaseUserPhone = UserDetailsModel.firebaseUsersPhone;
    firebaseUserDp = UserDetailsModel.firebaseUsersDp;
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    for (int i = 0; i < contacts.length; i++) {
      Contact contact = contacts.elementAt(i);

      String number;
      contact.phones!.isEmpty
          ? number = "No info"
          : number = contact.phones!.elementAt(0).value!;

      String invalidNumber = number;
      number = number.replaceAll(' ', '');
      int n = number.length;
      n >= 10 ? number = number.substring(n - 10) : number = invalidNumber;

      if (UserDetailsModel.firebaseUsersPhone.contains(number) &&
          number != UserDetailsModel.phone) {
        setState(() {
          myFriends.add(number);
        });
      }
    }

    myFriends = myFriends.toSet().toList();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: gradient2,
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        title: const Text("Chats"),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.search, size: 30),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.person, size: 30),
        //   ),
        // ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                if (contacts.isNotEmpty && myFriends.isNotEmpty)
                  (SizedBox(
                    height: MediaQuery.of(context).size.height * 0.779,
                    child: ListView.builder(
                      physics: ClampingScrollPhysics(),
                      itemCount: contacts.length,
                      itemBuilder: (context, index) {
                        Contact contact = contacts.elementAt(index);

                        String number;
                        contact.phones!.isEmpty
                            ? number = "No info"
                            : number = contact.phones!.elementAt(0).value!;

                        String invalidNumber = number;
                        number = number.replaceAll(' ', '');
                        int n = number.length;
                        n >= 10
                            ? number = number.substring(n - 10)
                            : number = invalidNumber;

                        int idx = -1;
                        for (int k = 0; k < myFriends.length; k++) {
                          if (number == myFriends[k]) {
                            idx = k;
                            myFriends[k] = "-1";
                          }
                        }

                        if (idx == -1) {
                          return Container();
                        } else {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                if (firebaseUserPhone.contains(number) &&
                                    number != UserDetailsModel.phone)
                                  ListTile(
                                      onTap: () async {
                                        pushNewScreen(
                                          context,
                                          screen: Chat(
                                            friendPhoneUid: number,
                                            contact: contact,
                                            dp: await getDp(number),
                                            isOnline: true,
                                            friendName:
                                                contact.displayName.toString(),
                                          ),
                                          withNavBar: false,
                                          // OPTIONAL VALUE. True by default.
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      },
                                      title: Text(contact.displayName ??
                                          'Contact Name'),
                                      subtitle: FutureBuilder(
                                          future: getLastMessage(number),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text('');
                                            }
                                            if (snapshot.data == null) {
                                              return Text(number);
                                            } else {
                                              String lastMessage =
                                                  snapshot.data.toString();
                                              return lastMessage.length >= 38
                                                  ? Text(lastMessage.substring(
                                                          0, 38) +
                                                      '...')
                                                  : Text(lastMessage);
                                            }
                                          }),
                                      leading: FutureBuilder(
                                        future: getDp(number),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircleAvatar(
                                              child: Icon(
                                                FontAwesomeIcons.user,
                                                color: Colors.white,
                                              ),
                                            );
                                          }
                                          if (snapshot.data == '') {
                                            return CircleAvatar(
                                              child: Icon(
                                                FontAwesomeIcons.user,
                                                color: Colors.white,
                                              ),
                                            );
                                          } else {
                                            return CircleAvatar(
                                              backgroundImage:
                                                  NetworkImage(snapshot.data),
                                            );
                                          }
                                        },
                                      )),
                                if (UserDetailsModel.firebaseUsersPhone
                                        .contains(number) &&
                                    number != UserDetailsModel.phone)
                                  Divider(
                                    thickness: 2,
                                    indent: 20,
                                    endIndent: 10,
                                  ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ))
                else if (!showSpinner)
                  (SizedBox(
                    width: size.width,
                    height: size.height - 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Please invite your friends to chat with them.",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        SizedBox(
                          height: 48,
                          width: 149.85,
                          child: GradientButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InviteFriend(contacts: contacts),
                                ),
                              );
                            },
                            child: Text('Invite +', style: kButtonTextStyle),
                            gradient: gradient1,
                          ),
                        ),
                      ],
                    ),
                  ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
