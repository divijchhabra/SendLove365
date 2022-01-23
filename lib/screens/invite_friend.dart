// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:url_launcher/url_launcher.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({Key? key, required this.contacts}) : super(key: key);

  final List<Contact> contacts;

  @override
  _InviteFriendState createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  TextEditingController phoneController = TextEditingController();

  Future<void> sendSms(phone) async {
    // print("SendSMS");

    // Todo :- Add your app play store link here
    String link = 'www.google.com';

    var uri =
        'sms:$phone?body=${UserDetailsModel.name} has invited you to Likeu. Download the app Likeu by using this $link';
    await launch(uri);
  }

  String searchField = "";

  bool resultData(List arr, int index, String _key) {
    Contact contact = arr.elementAt(index);

    String number = '';
    String displayName = '';

    contact.phones!.isEmpty
        ? number = "No info"
        : number = contact.phones!.elementAt(0).value!;

    String invalidNumber = number;
    number = number.replaceAll(' ', '');
    int n = number.length;
    n >= kCountryNumberLength
        ? number = number.substring(n - kCountryNumberLength)
        : number = invalidNumber;

    displayName = contact.displayName.toString();

    String phone = number;
    String name = displayName;
    phone = phone.toLowerCase();
    name = name.toLowerCase();
    _key = _key.toLowerCase();
    if (phone.contains(_key) || name.contains(_key)) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Phone Number', style: kTextStyle),
            SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Phone Number",
              ),
              controller: phoneController,
              onSaved: (phone) {
                phoneController.value =
                    phoneController.value.copyWith(text: phone);
              },
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: GradientButton(
                  onPressed: () async {
                    await sendSms(phoneController.text);
                    phoneController.text = '';
                  },
                  child: Text(
                    'Invite +',
                    style: kButtonTextStyle,
                  ),
                  gradient: gradient1,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(child: Text('Or', style: kTextStyle)),
            SizedBox(height: 10),
            Text('Search friend to invite', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Search Friend",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  searchField = val;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = widget.contacts.elementAt(index);

                  String number = '';
                  contact.phones!.isEmpty
                      ? number = "No info"
                      : number = contact.phones!.elementAt(0).value!;

                  String invalidNumber = number;
                  number = number.replaceAll(' ', '');
                  int n = number.length;
                  n >= kCountryNumberLength
                      ? number = number.substring(n - kCountryNumberLength)
                      : number = invalidNumber;

                  if ((resultData(widget.contacts, index, searchField)) ==
                      false) {
                    return SizedBox();
                  } else {
                    return searchField == '' ||
                            UserDetailsModel.firebaseUsersPhone.contains(number)
                        ? SizedBox()
                        : ListTile(
                            title: Text(contact.displayName ?? 'Contact Name'),
                            subtitle: Text(number),
                            trailing: InkWell(
                              onTap: () {
                                if (widget.contacts
                                    .elementAt(index)
                                    .phones!
                                    .isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'Invalid Contact Number');
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
                                      ? number = number
                                          .substring(n - kCountryNumberLength)
                                      : number = invalidNumber2;
                                  sendSms(numTp);
                                } // sendSms();
                              },
                              child: Text(
                                'Invite',
                                style: TextStyle(color: Color(0xFF7A3496)),
                              ),
                            ),
                            leading: (contact.avatar != null &&
                                    contact.avatar!.isNotEmpty)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!),
                                  )
                                : CircleAvatar(
                                    child: Text(contact.initials()),
                                  ),
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
