// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/UserLastMessage.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/screens/chat/chat.dart';

import '../invite_friends_screen.dart';
import 'dart:io';
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    if (Platform.isIOS ? await Permission.contacts.request().isGranted
        : await Permission.phone.request().isGranted
        && await Permission.contacts.request().isGranted) {
      await getContacts();
      setState(() {
        showSpinner = false;
      });
      // print('Hello ${contacts.length}');
    } else {
      setState(() {
        showSpinner = false;
      });
      if( Platform.isIOS )
        await Permission.contacts.request();
      else{
        await Permission.phone.request();
        await Permission.contacts.request();
      }

      Fluttertoast.showToast(
        msg: 'Provide Phone permission to make a call and view logs.',
      );
    }
  }

  List firebaseUserPhone = [];
  var lastMsg;

  @override
  void initState() {
    super.initState();
    checkPermissionPhoneLogs();
    firebaseUserPhone = UserDetailsModel.firebaseUsersPhone.toSet().toList();

    lastMsg = UserLastMessage.getLastMsg();
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    print('lastMsg');
    print(lastMsg);

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
        title: const Text("Chats"),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                (contacts.isNotEmpty && myFriends.isNotEmpty)
                    ? SizedBox(
                        height: 600,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
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

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                children: [
                                  if (firebaseUserPhone.contains(number) &&
                                      number != UserDetailsModel.phone)
                                    ListTile(
                                      onTap: () {
                                        pushNewScreen(
                                          context,
                                          screen: Chat(
                                            friendPhoneUid: number,
                                            contact: contact,
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
                        ),
                      )
                    : SizedBox(
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
                                      builder: (context) => InviteFriendScreen(
                                          contacts: contacts),
                                    ),
                                  );
                                },
                                child:
                                    Text('Invite +', style: kButtonTextStyle),
                                gradient: gradient1,
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
