// ignore_for_file: prefer_const_constructors

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({Key? key, required this.contacts})
      : super(key: key);

  final List<Contact> contacts;

  @override
  _InviteFriendScreen createState() => _InviteFriendScreen();
}

class _InviteFriendScreen extends State<InviteFriendScreen> {
  dynamic filtered;

  dynamic querySnapshot;

  Future<void> sendSms(phone) async {
    // print("SendSMS");

    // Todo :- Add your app play store link here
    String link = 'www.google.com';

    var uri =
        'sms:$phone?body=${UserDetailsModel.name!.toUpperCase()} has invited you to Likeu. Download the app Likeu by using this link $link';
    await launch(uri);
  }

  String number = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('+Invite friends'),
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: widget.contacts.length,
        itemBuilder: (context, index) {
          Contact contact = widget.contacts.elementAt(index);

          contact.phones!.isEmpty
              ? number = "No info"
              : number = contact.phones!.elementAt(0).value!;

          String invalidNumber = number;
          number = number.replaceAll(' ', '');
          int n = number.length;
          n >= kCountryNumberLength
              ? number = number.substring(n - kCountryNumberLength)
              : number = invalidNumber;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                if (!UserDetailsModel.firebaseUsersPhone.contains(number))
                  ListTile(
                    title: Text(contact.displayName ?? 'Contact Name'),
                    subtitle: Text(number),
                    trailing: InkWell(
                      onTap: () {
                        if (widget.contacts.elementAt(index).phones!.isEmpty) {
                          Fluttertoast.showToast(msg: 'Invalid Contact Number');
                        } else {
                          String numTp = widget.contacts
                              .elementAt(index)
                              .phones!
                              .elementAt(0)
                              .value!;

                          String invalidNumber2 = numTp;
                          numTp = numTp.replaceAll(' ', '');
                          int n = numTp.length;
                          n >= 10
                              ? number =
                                  number.substring(n - kCountryNumberLength)
                              : number = invalidNumber2;
                          sendSms(numTp);
                        } // sendSms();
                      },
                      child: Text(
                        'Invite',
                        style: TextStyle(color: Color(0xFF7A3496)),
                      ),
                    ),
                    leading:
                        (contact.avatar != null && contact.avatar!.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar!),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials()),
                              ),
                  ),
                if (!UserDetailsModel.firebaseUsersPhone.contains(number))
                  Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 10,
                    color: Color(0xff7A3496).withOpacity(0.3),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
