// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/screens/invite_friends_screen.dart';
import 'package:temp/screens/message_sent_screen.dart';

class SendImageScreen extends StatefulWidget {
  const SendImageScreen({
    Key? key,
    required this.contacts,
    required this.imageUrl,
  }) : super(key: key);

  final List<Contact> contacts;
  final String imageUrl;

  @override
  _SendImageScreen createState() => _SendImageScreen();
}

class _SendImageScreen extends State<SendImageScreen> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  String currentUserId = UserDetailsModel.phone.toString();
  dynamic chatDocId;

  String friendPhoneUid = '';

  Future<void> checkUser() async {
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
            } else {
              // print('I am here');
              await chats.add({
                'users': {currentUserId: null, friendPhoneUid: null}
              }).then(
                (value) async {
                  setState(() {
                    chatDocId = value.id;
                    showSpinner = false;
                  });

                  // print('value $chatDocId');
                },
              );
            }
          },
        )
        .catchError((error) {
          Fluttertoast.showToast(msg: error.toString());
          // print('bad $error');
          setState(() {
            showSpinner = false;
          });
        });
  }

  void _sendMessage(String msg, bool isMsg) async {
    if (msg == '' && isMsg) {
      Fluttertoast.showToast(msg: 'Type something...');
    }

    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'senderPhoneId': currentUserId,
      'message': msg,
      'isMsg': isMsg,
    }).then((value) {
      // print(value);
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.message);
    });
  }

  late List<Contact> contacts = [];
  late List<String> myFriends = [];

  Future<void> getContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts.toSet().toList();
    });
  }

  Future<void> checkPermissionPhoneLogs() async {
    setState(() {
      showSpinner = true;
    });
    if (await Permission.phone.request().isGranted &&
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
      await Permission.contacts.request();
      await Permission.phone.request();

      Fluttertoast.showToast(
        msg: 'Provide Phone permission to make a call and view logs.',
      );
    }
  }

  bool showSpinner = false;
  bool showSpinner2 = false;
  List firebaseUserPhone = [];

  @override
  void initState() {
    super.initState();
    checkPermissionPhoneLogs();
    firebaseUserPhone = UserDetailsModel.firebaseUsersPhone.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    // print('contacts');
    // print(contacts.length);

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
        title: const Text("Send To"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 30),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person, size: 30),
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  (contacts.isNotEmpty && myFriends.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
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

                            Color myColor = Colors.transparent;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  if (firebaseUserPhone.contains(number) &&
                                      number != UserDetailsModel.phone)
                                    ListTile(
                                      tileColor: myColor,
                                      onTap: () async {
                                        setState(() {
                                          friendPhoneUid = number;
                                          showSpinner2 = true;
                                        });
                                        await checkUser();
                                        _sendMessage(widget.imageUrl, false);

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MessageSent()),
                                        );
                                      },
                                      title: Text(contact.displayName ??
                                          'Contact Name'),
                                      subtitle: Text(number),
                                      leading: (contact.avatar != null &&
                                              contact.avatar!.isNotEmpty)
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  MemoryImage(contact.avatar!),
                                            )
                                          : CircleAvatar(
                                              child: Text(contact.initials()),
                                            ),
                                    ),
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
                          },
                        )
                      : SizedBox(
                          width: size.width,
                          height: size.height - 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Please invite your friends to send them images.",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              SizedBox(
                                height: 48,
                                width: 149.85,
                                child: GradientButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InviteFriendScreen(
                                                contacts: contacts),
                                      ),
                                    );
                                  },
                                  child: showSpinner2
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(
                                              color: Colors.white),
                                        )
                                      : Text('Invite +',
                                          style: kButtonTextStyle),
                                  gradient: gradient1,
                                ),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 35),
                  (contacts.isNotEmpty && myFriends.isNotEmpty)
                      ? SizedBox(
                          height: 48,
                          width: 149.85,
                          child: GradientButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InviteFriendScreen(contacts: contacts),
                                ),
                              );
                            },
                            child: showSpinner2
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                        color: Colors.white),
                                  )
                                : Text('Invite +', style: kButtonTextStyle),
                            gradient: gradient1,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
