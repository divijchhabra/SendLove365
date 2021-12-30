// ignore_for_file: prefer_const_constructors

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/message_model.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/models/user_model.dart';
import 'package:temp/screens/chat_2_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Contact> contacts = [];

  Future<void> getContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
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
      print('Hello ${contacts.length}');
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

  @override
  void initState() {
    super.initState();
    // showSpinner=true;
    checkPermissionPhoneLogs();
  }

  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
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
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
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
                        if (!UserDetailsModel.firebaseUsersPhone
                            .contains(number)) {
                          print(number);
                        }
                        print('Hello');
                        for (var i in UserDetailsModel.firebaseUsersPhone) {
                          print(i);
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              if (UserDetailsModel.firebaseUsersPhone
                                  .contains(number))
                                ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SecondChatScreen(
                                          user: User(
                                              id: 1,
                                              name: contact.displayName
                                                  .toString(),
                                              imageUrl:
                                                  contact.avatar.toString(),
                                              isOnline: false),
                                        ),
                                      ),
                                    );
                                  },
                                  title: Text(
                                      contact.displayName ?? 'Contact Name'),
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
                                  // 9579699645
                                ),
                              if (UserDetailsModel.firebaseUsersPhone
                                  .contains(number))
                                Divider(
                                    thickness: 2, indent: 20, endIndent: 10),
                            ],
                          ),
                        );
                      },
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
}
