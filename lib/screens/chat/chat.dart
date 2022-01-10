// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/UserLastMessage.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/screens/chat/chat_bubble.dart';
import 'package:temp/screens/send_a_gift_screen.dart';

class Chat extends StatefulWidget {
  Chat({
    Key? key,
    required this.friendPhoneUid,
    required this.contact,
    required this.isOnline,
    required this.friendName,
  }) : super(key: key);

  final String friendPhoneUid, friendName;
  Contact contact;
  final bool isOnline;

  @override
  _ChatState createState() => _ChatState();
}

int _index = 2;

class _ChatState extends State<Chat> {
  // image source
  // File? _image;
  List<Map<String, String>> lastMsg = [];

  // upload task
  UploadTask? task;

  String? urlDownload;

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  final _textController = TextEditingController();

  String currentUserId = UserDetailsModel.phone.toString();
  dynamic chatDocId;

  Future<void> checkUser() async {
    await chats
        .where('users',
            isEqualTo: {widget.friendPhoneUid: null, currentUserId: null})
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
                'users': {currentUserId: null, widget.friendPhoneUid: null}
              }).then(
                (value) async {
                  setState(() {
                    chatDocId = value.id;
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

  List<String> imageUrl = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyWLsRHTJd8vXnQWVOd7k_N1pOkD9T_1oOAw&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSb17jkNYYV09jEwBn4Xujo4-xpV66mDr74Mg&usqp=CAU',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSy0pxXVnc-vsxBbOByNPqBtw394iWBT2H-YQ&usqp=CAU',
  ];

  List<Images> cards = [];

  @override
  void initState() {
    super.initState();
    _index = 2;

    for (int i = 0; i < imageUrl.length; i++) {
      cards.add(Images(imageLink: imageUrl[i]));
    }
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
          dynamic data;
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
                  ],
                ),
              ),
              leadingWidth: MediaQuery.of(context).size.width * 0.22,
              leading: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: (widget.contact.avatar != null &&
                            widget.contact.avatar!.isNotEmpty)
                        ? CircleAvatar(
                            backgroundImage:
                                MemoryImage(widget.contact.avatar!),
                          )
                        : CircleAvatar(
                            child: Text(widget.contact.initials()),
                          ),
                  ),
                ],
              ),
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
                          // print(document.toString());
                          // print(data['msg']);
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: ChatBubble(
                              message: data['message'],
                              isMe: isSender(data['senderPhoneId']),
                              isSameUser: isSender(data['senderPhoneId']),
                              createdOn: data['createdOn'] == null
                                  ? DateTime.now().toString()
                                  : data['createdOn'].toDate().toString(),
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
          IconButton(
            icon: const Icon(Icons.attach_file),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (builder) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        const Text(
                          "Select an image to send to your loved ones",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: kPrimaryColor,
                          ),
                          child: Stack(children: cards),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () async {
                            await _sendMessage(imageUrl[_index], false);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: kPrimaryColor,
                            ),
                            child: Image.asset('assets/Group 229.png'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          // InkWell(
          //   onTap: () async {
          //     // print('Hello');
          //     await getImage();
          //     await uploadImage();
          //   },
          //   child: Icon(Icons.attach_file_outlined),
          // ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 24,
              child: TextField(
                cursorHeight: 17,
                showCursor: true,
                style: TextStyle(fontSize: 14, height: 1),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(8, 2, 2, 2),
                  fillColor: const Color(0xffD9D9D9).withOpacity(0.3),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
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
            onPressed: () async {
              // todo shared preference
              lastMsg.add(
                  {widget.friendPhoneUid.toString(): _textController.text});
              await UserLastMessage.setLastMsg(lastMsg);
              await _sendMessage(_textController.text, true);
            },
          ),
        ],
      ),
    );
  }

  Future _sendMessage(String msg, bool isMsg) async {
    if (msg == '' && isMsg) return;

    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'senderPhoneId': currentUserId,
      'message': msg,
      'isMsg': isMsg,
    }).then((value) {
      if (!isMsg) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => super.widget,
          ),
        );
        // Navigator.pop(context);
      } else {
        _textController.text = '';
      }
    }).catchError((error) {
      Fluttertoast.showToast(msg: error.message);
    });
  }
}

class Images extends StatefulWidget {
  const Images({Key? key, required this.imageLink}) : super(key: key);

  final String imageLink;

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    return Swipable(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: 368,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
            image: NetworkImage(widget.imageLink),
            fit: BoxFit.cover,
          ),
        ),
      ),
      onSwipeEnd: (offSet, value) {
        print('_index');
        print(_index);
        setState(() {
          _index -= 1;
        });
      },
    );
  }
}
