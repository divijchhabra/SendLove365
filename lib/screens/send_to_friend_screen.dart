// ignore_for_file: prefer_const_constructors

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/models/user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SendToFriend extends StatefulWidget {
  const SendToFriend({Key? key, required this.contacts}) : super(key: key);

  final List<Contact> contacts;

  @override
  _SendToFriendState createState() => _SendToFriendState();
}

class _SendToFriendState extends State<SendToFriend> {
  User? user;

  dynamic filtered;

  dynamic querySnapshot;

  Future<void> sendSms(phone) async {
    // print("SendSMS");

    // Todo :- Add your app play store link here
    String link = 'www.google.com';

    var uri =
        'sms:$phone?body=Hello there! Download the app SendLove365 by using this $link';
    await launch(uri);
  }

  String number = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temp'),
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
          n >= 10 ? number = number.substring(n - 10) : number = invalidNumber;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                if (UserDetailsModel.firebaseUsersPhone.contains(number))
                  ListTile(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => SecondChatScreen(
                      //       user: User(
                      //         id: 1,
                      //         name: contact.displayName.toString(),
                      //         imageUrl: contact.avatar.toString(),
                      //         isOnline: true,
                      //       ),
                      //     ),
                      //   ),
                      // );
                      // todo something
                    },
                    title: Text(contact.displayName ?? 'Contact Name'),
                    subtitle: Text(number),
                    leading:
                        (contact.avatar != null && contact.avatar!.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar!),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials()),
                              ),
                  ),
                if (UserDetailsModel.firebaseUsersPhone.contains(number))
                  Divider(
                    thickness: 2,
                    indent: 20,
                    endIndent: 10,
                    color: Color(0xff7A3496).withOpacity(0.3),
                  ),
                // else
                //   ListTile(
                //     title: Text(contact.displayName ?? 'Contact Name'),
                //     subtitle: Text(number),
                //     leading:
                //         (contact.avatar != null && contact.avatar!.isNotEmpty)
                //             ? CircleAvatar(
                //                 backgroundImage: MemoryImage(contact.avatar!),
                //               )
                //             : CircleAvatar(
                //                 child: Text(contact.initials()),
                //               ),
                //     // 9579699645
                //     trailing: InkWell(
                //       onTap: () async {
                //         print(index);
                //         widget.contacts.elementAt(index).phones!.isEmpty
                //             ? Fluttertoast.showToast(
                //                 msg: 'Invalid Contact Number')
                //             : Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                   builder: (context) => SecondChatScreen(
                //                     user: User(
                //                         id: 1,
                //                         name: contact.displayName.toString(),
                //                         imageUrl: contact.avatar.toString(),
                //                         isOnline: false),
                //                   ),
                //                 ),
                //               );
                //       },
                //       child: Text(
                //         'Chat',
                //         style: TextStyle(color: Colors.red),
                //       ),
                //     ),
                //   ),
                // Divider(thickness: 2, indent: 20, endIndent: 10),
              ],
            ),
          );
        },
      ),
    );
  }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       toolbarHeight: 90,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           bottom: Radius.circular(30),
//         ),
//       ),
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: gradient2,
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//       ),
//       title: const Text("Send To"),
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new),
//         onPressed: () {},
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.search, size: 30),
//         ),
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.person, size: 30),
//         ),
//       ],
//     ),
//     body: SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 height: 500,
//                 child: ListView.separated(
//                   separatorBuilder: (context, index) {
//                     return Divider(
//                       thickness: 1,
//                       color: Color(0xff7A3496).withOpacity(0.3),
//                       indent: 20,
//                       endIndent: 20,
//                     );
//                   },
//                   scrollDirection: Axis.vertical,
//                   physics: const BouncingScrollPhysics(),
//                   itemCount: chats.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     final Message chat = chats[index];
//                     return GestureDetector(
//                       onTap: () {
//                         if (_selectedItems.isEmpty ||
//                             !_selectedItems.contains(index)) {
//                           setState(() {
//                             _selectedItems.add(index);
//                           });
//                         } else {
//                           setState(() {
//                             _selectedItems.removeWhere((val) => val == index);
//                           });
//                         }
//                       },
//                       child: Container(
//                         height: 69,
//                         width: 400,
//                         decoration: BoxDecoration(
//                           color: (_selectedItems.contains(index))
//                               ? Colors.purple.shade50
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 8, vertical: 15),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: 2,
//                                   color: Theme.of(context).primaryColor,
//                                 ),
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 2,
//                                     blurRadius: 5,
//                                   ),
//                                 ],
//                               ),
//                               child: const CircleAvatar(
//                                 radius: 22.5,
//                                 backgroundImage: NetworkImage(
//                                     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAsK6oIKzeSCKiqpjv5cuoC4ZC_hJ0FxNkvQ&usqp=CAU'),
//                               ),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.8,
//                               padding: const EdgeInsets.only(left: 20),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         chat.sender.name,
//                                         style: const TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   // const SizedBox(height: 10),
//                                   Container(
//                                     alignment: Alignment.topLeft,
//                                     child: const Text(
//                                       "Hey there!",
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         color: Colors.black54,
//                                       ),
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 2,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // SizedBox(
//               //   height: 470,
//               //   child: ListView.separated(
//               //     separatorBuilder: (context, index) {
//               //       return const Divider(
//               //         thickness: 2,
//               //         indent: 60,
//               //         endIndent: 50,
//               //       );
//               //     },
//               //     scrollDirection: Axis.vertical,
//               //     physics: const BouncingScrollPhysics(),
//               //     itemCount: chats.length,
//               //     itemBuilder: (BuildContext context, int index) {
//               //       final Message chat = chats[index];
//               //       return GestureDetector(
//               //
//               //         child: Container(
//               //           height: 75,
//               //           width: 368,
//               //           decoration: BoxDecoration(
//               //             color: (_selectedItems.contains(index))
//               //                 ? Colors.purple.shade50
//               //                 : Colors.transparent,
//               //             borderRadius: BorderRadius.circular(10.0),
//               //           ),
//               //           padding: const EdgeInsets.symmetric(
//               //               horizontal: 8, vertical: 15),
//               //           child: Row(
//               //             children: [
//               //               Container(
//               //                 padding: const EdgeInsets.all(2),
//               //                 decoration: BoxDecoration(
//               //                   border: Border.all(
//               //                     width: 2,
//               //                     color: Theme.of(context).primaryColor,
//               //                   ),
//               //                   shape: BoxShape.circle,
//               //                   boxShadow: [
//               //                     BoxShadow(
//               //                       color: Colors.grey.withOpacity(0.5),
//               //                       spreadRadius: 2,
//               //                       blurRadius: 5,
//               //                     ),
//               //                   ],
//               //                 ),
//               //                 child: const CircleAvatar(
//               //                   radius: 30,
//               //                   backgroundImage: NetworkImage(
//               //                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAsK6oIKzeSCKiqpjv5cuoC4ZC_hJ0FxNkvQ&usqp=CAU'),
//               //                 ),
//               //               ),
//               //               Container(
//               //                 width: MediaQuery.of(context).size.width * 0.65,
//               //                 padding: const EdgeInsets.only(left: 20),
//               //                 child: Column(
//               //                   mainAxisAlignment: MainAxisAlignment.center,
//               //                   crossAxisAlignment: CrossAxisAlignment.center,
//               //                   children: [
//               //                     Row(
//               //                       mainAxisAlignment:
//               //                           MainAxisAlignment.spaceBetween,
//               //                       children: [
//               //                         Text(
//               //                           chat.sender.name,
//               //                           style: const TextStyle(
//               //                             fontSize: 16,
//               //                             fontWeight: FontWeight.bold,
//               //                           ),
//               //                         ),
//               //                       ],
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ),
//               //             ],
//               //           ),
//               //         ),
//               //       );
//               //     },
//               //   ),
//               // ),
//               const SizedBox(height: 35),
//               SizedBox(
//                 height: 48,
//                 width: 149.85,
//                 child: GradientButton(
//                     onPressed: () async {
//                       await getContacts();
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const MessageSent()),
//                       );
//                     },
//                     child: const Text(
//                       "Send",
//                       style: kButtonTextStyle,
//                     ),
//                     gradient: gradient1),
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
}
