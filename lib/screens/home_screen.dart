// ignore_for_file: prefer_const_constructors

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/screens/send_a_gift_screen.dart';
import 'package:temp/screens/send_to_friend_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> checkPermissionPhoneLogs() async {
    if (await Permission.phone.request().isGranted &&
        await Permission.contacts.request().isGranted) {
      await getContacts();
      print('Hello ${contacts.length}');
      pushNewScreen(
        context,
        screen: SendToFriend(contacts: contacts),
        withNavBar: false,
        // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
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

  late List<Contact> contacts = [];

  Future<void> getContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
    });
  }

  getData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var name = data['userName'].toString();
      var phone = data['phoneNo'].toString();

      int pn = phone.length;
      setState(() {
        UserDetailsModel.firebaseUsersPhone.add(phone.substring(pn - 10));
      });
    }
  }

  int selectedItem = 0;

  void _openSimpleItemPicker(BuildContext context) {
    BottomPicker(
      items: const [
        Text("See All"),
        Text("Love"),
        Text("Friends"),
        Text("Holidays"),
        Text("Birthdays")
      ],
      title: 'Choose something',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      // backgroundColor: Colors.yellow.withOpacity(0.6),
      bottomPickerTheme: BOTTOM_PICKER_THEME.plumPlate,
      onSubmit: (index) {},
    ).show(context);
  }

  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
        color: kSecondaryColor,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Send Love 365 banner cat.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: kPrimaryColor,
                          ),
                          child: IconButton(
                            // alignment: const Alignment(85, 3),
                            onPressed: () {
                              _openSimpleItemPicker(
                                context,
                              );
                            },
                            highlightColor: kPrimaryColor,

                            icon: const Icon(
                              Icons.menu_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: kPrimaryColor,
                      ),
                      height: 350,
                      width: 368,
                    ),
                    const SizedBox(height: 20),
                    // GradientIconButton(
                    //     onPressed: () {},
                    //     child: const Text("Send to friend"),
                    //     gradient: gradient1,
                    //     icon: Icon(Icons.arrow_forward)),
                    SizedBox(
                      height: 48,
                      width: 223.5,
                      child: GradientButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          await checkPermissionPhoneLogs();
                          setState(() {
                            showSpinner = false;
                          });
                        },
                        child: const Text(
                          "Send to friend",
                          style: kButtonTextStyle,
                        ),
                        gradient: gradient1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 48,
                      width: 223.5,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          side: const BorderSide(
                            width: 2,
                            color: kPrimaryColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        onPressed: () {
                          pushNewScreen(
                            context,
                            screen: SendAGift(),
                            withNavBar: false,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        icon: const Icon(Icons.card_giftcard),
                        label: const Text(
                          "Send a gift",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    // BottomNav(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
