// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/screens/chat/chat_bubble.dart';
import 'package:temp/screens/send_a_gift_screen.dart';
import 'package:temp/services/firebase_upload.dart';
import 'package:path/path.dart' as path;

class Chat extends StatefulWidget {
  const Chat({
    Key? key,
    required this.friendPhoneUid,
    required this.avatar,
    required this.isOnline,
    required this.friendName,
  }) : super(key: key);

  final String friendPhoneUid, friendName, avatar;
  final bool isOnline;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // image source
  File? _image;

  // upload task
  UploadTask? task;

  String? urlDownload;

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  final _textController = TextEditingController();

  String currentUserId = UserDetailsModel.phone.toString();
  var chatDocId;

  Future<void> checkUser() async {
    await chats
        .where('users',
            isEqualTo: {widget.friendPhoneUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            print(querySnapshot.docs.isEmpty);
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });

              print('value $chatDocId');
            } else {
              print('I am here');
              await chats.add({
                'users': {currentUserId: null, widget.friendPhoneUid: null}
              }).then(
                (value) async {
                  setState(() {
                    chatDocId = value.id;
                  });

                  print('value $chatDocId');
                },
              );
            }
          },
        )
        .catchError((error) {
          Fluttertoast.showToast(msg: error.toString());
          print('bad $error');
        });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          var data;
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 90,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: gradient2,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              centerTitle: true,
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.friendName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const TextSpan(text: '\n'),
                    widget.isOnline
                        ? const TextSpan(
                            text: 'Online',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        : const TextSpan(
                            text: 'Offline',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ],
                ),
              ),
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          data = document.data()!;
                          print(document.toString());
                          print(data['msg']);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            // child: ChatBubble(
                            //   clipper: ChatBubbleClipper6(
                            //     nipSize: 0,
                            //     radius: 0,
                            //     type: isSender(data['senderPhoneId'].toString())
                            //         ? BubbleType.sendBubble
                            //         : BubbleType.receiverBubble,
                            //   ),
                            //   alignment: getAlignment(
                            //       data['senderPhoneId'].toString()),
                            //   margin: EdgeInsets.only(top: 20),
                            //   backGroundColor:
                            //       isSender(data['senderPhoneId'].toString())
                            //           ? Color(0xFF08C187)
                            //           : Color(0xffE7E7ED),
                            //   child: Container(
                            //     constraints: BoxConstraints(
                            //       maxWidth:
                            //           MediaQuery.of(context).size.width * 0.7,
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           children: [
                            //             Text(data['message'],
                            //                 style: TextStyle(
                            //                     color: isSender(
                            //                             data['senderPhoneId']
                            //                                 .toString())
                            //                         ? Colors.white
                            //                         : Colors.black),
                            //                 maxLines: 100,
                            //                 overflow: TextOverflow.ellipsis)
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: [
                            //             Text(
                            //               data['createdOn'] == null
                            //                   ? DateTime.now().toString()
                            //                   : data['createdOn']
                            //                       .toDate()
                            //                       .toString(),
                            //               style: TextStyle(
                            //                   fontSize: 10,
                            //                   color: isSender(
                            //                           data['senderPhoneId']
                            //                               .toString())
                            //                       ? Colors.white
                            //                       : Colors.black),
                            //             )
                            //           ],
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            child: ChatBubble(
                              message: data['message'],
                              isMe: isSender(data['senderPhoneId']),
                              isSameUser: isSender(data['senderPhoneId']),
                              createdOn: data['createdOn'] == null
                                  ? DateTime.now().toString()
                                  : data['createdOn'].toDate().toString(),
                              avatar: widget.avatar,
                              isMsg: data['isMsg'],
                              urlDownload: data['message'].toString(),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  _sendMessageArea()
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        color: Colors.white,
      ),
      height: 74,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SendAGift(),
                ),
              );
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.attach_file),
          //   iconSize: 25,
          //   color: Theme.of(context).primaryColor,
          //   onPressed: () {
          //     showModalBottomSheet(
          //       context: context,
          //       isScrollControlled: true,
          //       shape: const RoundedRectangleBorder(
          //         borderRadius:
          //             BorderRadius.vertical(top: Radius.circular(25.0)),
          //       ),
          //       builder: (builder) {
          //         return Container(
          //           height: MediaQuery.of(context).size.height * 0.6,
          //           padding: const EdgeInsets.all(8),
          //           child: Column(
          //             children: [
          //               const SizedBox(height: 5),
          //               const Text(
          //                 "Select an image to send to your loved ones",
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(fontSize: 14),
          //               ),
          //               const SizedBox(height: 20),
          //               Container(
          //                 height: 300,
          //                 width: 300,
          //                 decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(10.0),
          //                   image: DecorationImage(
          //                       image: AssetImage('assets/jk.png')),
          //                   color: kPrimaryColor,
          //                 ),
          //               ),
          //               const SizedBox(height: 20),
          //               InkWell(
          //                 onTap: () {
          //                   Navigator.pop(context);
          //                 },
          //                 child: Container(
          //                   height: 47,
          //                   width: 47,
          //                   decoration: BoxDecoration(
          //                     borderRadius: BorderRadius.circular(50.0),
          //                     color: kPrimaryColor,
          //                   ),
          //                   child: Image.asset('assets/Group 229.png'),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       },
          //     );
          //   },
          // ),
          InkWell(
            onTap: () async {
              print('Hello');
              await getImage();
              await uploadImage();
            },
            child: Icon(Icons.attach_file_outlined),
          ),
          Expanded(
            child: SizedBox(
              height: 40,
              width: 24,
              child: TextField(
                cursorHeight: 30,
                style: TextStyle(
                  fontSize: 14,
                  height: 1,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                  fillColor: const Color(0xffD9D9D9).withOpacity(0.3),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.white)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(color: Colors.white)),
                  focusColor: const Color(0xFFEEEEEE),
                  hoverColor: const Color(0xFFEEEEEE),
                  hintText: 'Type Something',
                ),
                textCapitalization: TextCapitalization.sentences,
                controller: _textController,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _sendMessage(_textController.text, true);
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String msg, bool isMsg) {
    if (msg == '' && isMsg) return;

    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'senderPhoneId': currentUserId,
      'message': msg,
      'isMsg': isMsg,
    }).then((value) {
      _textController.text = '';
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.message);
    });
  }

  // Pick image
  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imgTemp = File(image.path);

      setState(() {
        _image = imgTemp;
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

  // Upload image
  Future uploadImage() async {
    print('image $_image');
    if (_image == null) return;

    final imageName = path.basename(_image!.path);
    final destination = 'chats/$imageName';

    task = FirebaseUpload.uploadFile(destination, _image!);

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    print('urlDownload $urlDownload');
    _sendMessage(urlDownload!, false);
  }
}
