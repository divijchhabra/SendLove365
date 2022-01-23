// ignore_for_file: prefer_const_constructors

import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/constants.dart';
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
    required this.dp,
  }) : super(key: key);

  final String friendPhoneUid, friendName, dp;
  Contact contact;
  final bool isOnline;

  @override
  _ChatState createState() => _ChatState();
}

int _index = 0;

class _ChatState extends State<Chat> {
  int _choice = 0;

// image source
  // File? _image;
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

  _openSimpleItemPicker(BuildContext context) {
    BottomPicker(
      items: const [
        Text("See All", style: kBottomText),
        Text("Valentine", style: kBottomText),
        Text("Anniversary", style: kBottomText),
        Text("Birthdays", style: kBottomText),
        Text("Holidays", style: kBottomText),
        Text("Love", style: kBottomText),
        Text("Friends", style: kBottomText),
      ],
      selectedItemIndex: _choice,
      title: 'Choose something',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
      ),
      backgroundColor: Color(0xFF7A3496),
      bottomPickerTheme: BOTTOM_PICKER_THEME.plumPlate,
      onSubmit: (index) {
        print('index $index');
        setState(() {
          _choice = index;
          changeData(index);
          _index = cards.length - 1;
        });
      },
    ).show(context);
  }

  bool showSpinner = false;

  List<String> valentine = [];
  List<String> anniversary = [];
  List<String> birthday = [];
  List<String> holiday = [];
  List<String> love = [];
  List<String> friend = [];
  List<String> all = [];

  getImageData() async {
    var valentineCollection =
        FirebaseFirestore.instance.collection('Valentines');
    var anniversaryCollection =
        FirebaseFirestore.instance.collection('Anniversary');
    var birthdayCollection = FirebaseFirestore.instance.collection('Birthday');
    var holidaysCollection = FirebaseFirestore.instance.collection('Holidays');
    var loveCollection = FirebaseFirestore.instance.collection('Love');
    var friendCollection = FirebaseFirestore.instance.collection('Friends');

    var querySnapshot1 = await valentineCollection.get();
    var querySnapshot2 = await anniversaryCollection.get();
    var querySnapshot3 = await birthdayCollection.get();
    var querySnapshot4 = await holidaysCollection.get();
    var querySnapshot5 = await loveCollection.get();
    var querySnapshot6 = await friendCollection.get();

    for (var queryDocumentSnapshot in querySnapshot1.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var image = data['image'].toString();

      print('Valentine $image');

      setState(() {
        valentine.add(image);
        all.add(image);
      });
    }
    for (var queryDocumentSnapshot in querySnapshot2.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var image = data['image'].toString();

      print('Anniversary $image');

      setState(() {
        anniversary.add(image);
        all.add(image);
      });
    }
    for (var queryDocumentSnapshot in querySnapshot3.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var image = data['image'].toString();

      print('Birthday $image');

      setState(() {
        birthday.add(image);
        all.add(image);
      });
    }
    for (var queryDocumentSnapshot in querySnapshot4.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var image = data['image'].toString();

      print('Holiday $image');

      setState(() {
        holiday.add(image);
        all.add(image);
      });
    }
    for (var queryDocumentSnapshot in querySnapshot5.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var image = data['image'].toString();

      print('Love $image');

      setState(() {
        love.add(image);
        all.add(image);
      });
    }
    for (var queryDocumentSnapshot in querySnapshot6.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var image = data['image'].toString();

      print('Friend $image');

      setState(() {
        friend.add(image);
        all.add(image);
      });
    }
  }

  void changeData(int ch) {
    print('dkf $ch');
    switch (ch) {
      case 0:
        {
          cards.clear();
          for (int i = 0; i < all.length; i++) {
            cards.add(Images(imageLink: all[i]));
          }
        }
        break;
      case 1:
        {
          cards.clear();
          for (int i = 0; i < valentine.length; i++) {
            cards.add(Images(imageLink: valentine[i]));
          }
        }
        break;
      case 2:
        {
          cards.clear();
          for (int i = 0; i < anniversary.length; i++) {
            cards.add(Images(imageLink: anniversary[i]));
          }
        }
        break;
      case 3:
        {
          cards.clear();
          for (int i = 0; i < birthday.length; i++) {
            cards.add(Images(imageLink: birthday[i]));
          }
        }
        break;
      case 4:
        {
          cards.clear();
          for (int i = 0; i < holiday.length; i++) {
            cards.add(Images(imageLink: holiday[i]));
          }
        }
        break;
      case 5:
        {
          cards.clear();
          for (int i = 0; i < love.length; i++) {
            cards.add(Images(imageLink: love[i]));
          }
        }
        break;
      case 6:
        {
          cards.clear();
          for (int i = 0; i < friend.length; i++) {
            cards.add(Images(imageLink: friend[i]));
          }
        }
        break;
    }

    print('cards ${cards.length}');
    if (_index == 0 && cards.isNotEmpty) {
      setState(() {
        _index = cards.length - 1;
      });
    }
    print('indexS $_index');
  }

  List<Images> cards = [];

  @override
  void initState() {
    // getImageData();
    super.initState();
    _index = 0;
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    changeData(_choice);

    return WillPopScope(
      onWillPop: () {
        pushNewScreen(
          context,
          screen: BottomNav(index: 1),
          withNavBar: false,
          // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );

        return Future.value(false);
      },
      child: StreamBuilder<QuerySnapshot>(
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
                leadingWidth: MediaQuery.of(context).size.width * 0.25,
                leading: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        color: Colors.white,
                        onPressed: () {
                          pushNewScreen(
                            context,
                            screen: BottomNav(index: 1),
                            withNavBar: false,
                            // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                          // Navigator.pop(context);
                        }),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(widget.dp),
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
      ),
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
            onPressed: () async {
              // await getImageData();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (context) {
                  return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return FutureBuilder(
                      future: getImageData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height * 0.6,
                              // width: 40,
                              child:
                                  CircularProgressIndicator() // Text('Loading...'),
                              );
                        } else {
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: kPrimaryColor,
                                    ),
                                    child: IconButton(
                                      // alignment: const Alignment(85, 3),
                                      onPressed: () {
                                        // _openSimpleItemPicker(
                                        //   context,
                                        // );
                                        BottomPicker(
                                          items: const [
                                            Text("See All", style: kBottomText),
                                            Text("Valentine",
                                                style: kBottomText),
                                            Text("Anniversary",
                                                style: kBottomText),
                                            Text("Birthdays",
                                                style: kBottomText),
                                            Text("Holidays",
                                                style: kBottomText),
                                            Text("Love", style: kBottomText),
                                            Text("Friends", style: kBottomText),
                                          ],
                                          selectedItemIndex: _choice,
                                          title: 'Choose something',
                                          titleStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: Color(0xFF7A3496),
                                          bottomPickerTheme:
                                              BOTTOM_PICKER_THEME.plumPlate,
                                          onSubmit: (index) {
                                            print('index $index');
                                            setState(() {
                                              _choice = index;
                                              changeData(index);
                                              _index = cards.length - 1;
                                            });
                                          },
                                        ).show(context);
                                      },
                                      highlightColor: kPrimaryColor,

                                      icon: const Icon(
                                        Icons.menu_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.38,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: kPrimaryColor,
                                  ),
                                  child: cards.isEmpty
                                      ? Text('Choose another category')
                                      : Stack(children: cards),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  onTap: () async {
                                    if (_choice == 0 && _index == 0) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please select another category');
                                      return;
                                    }
                                    if (_index == -1) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Please select another category');
                                      return;
                                    }
                                    await _sendMessage(
                                        _choice == 0
                                            ? all[_index]
                                            : _choice == 1
                                                ? valentine[_index]
                                                : _choice == 2
                                                    ? anniversary[_index]
                                                    : _choice == 3
                                                        ? birthday[_index]
                                                        : _choice == 4
                                                            ? holiday[_index]
                                                            : _choice == 5
                                                                ? love[_index]
                                                                : friend[
                                                                    _index],
                                        false);
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
                        }
                      },
                    );
                  });
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
            fit: BoxFit.fill,
          ),
        ),
      ),
      onSwipeEnd: (offSet, value) {
        print('_index');
        print(_index);
        setState(() {
          _index -= 1;
        });
        if (_index == -1) {
          Fluttertoast.showToast(msg: 'Please select another category');
          return;
        }
      },
    );
  }
}
