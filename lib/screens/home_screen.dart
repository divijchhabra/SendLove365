// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_swipable/flutter_swipable.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/components/likeu_appbar.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/providers/bottom_nav_provider.dart';
import 'package:temp/providers/home_index_provider.dart';
import 'package:temp/screens/send_image_screen.dart';
import 'package:temp/screens/send_a_gift_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int _index = 0;

class _HomeScreenState extends State<HomeScreen> {
  int _choice = 0;

  Future<void> checkPermissionPhoneLogs() async {
    if (Platform.isIOS
        ? await Permission.contacts.request().isGranted
        : await Permission.phone.request().isGranted &&
            await Permission.contacts.request().isGranted) {
      await getContacts();
      // print('Hello ${contacts.length}');
      print('_index');
      print(_index.toString());

      pushNewScreen(
        context,
        screen: SendImageScreen(
          contacts: contacts,
          imageUrl: _choice == 0
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
                                  : friend[_index],
        ),
        withNavBar: false,
        // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else {
      setState(() {
        showSpinner = false;
      });
      if (Platform.isIOS) {
        await Permission.contacts.request();
      } else {
        await Permission.phone.request();
        await Permission.contacts.request();
      }

      Fluttertoast.showToast(
        msg: 'Provide Phone permission to view logs.',
      );
    }
  }

  late List<Contact> contacts = [];

  Future<void> getContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts.toSet().toList();
    });
  }

  getData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      var phone = data['phoneNo'].toString();
      var dp = data['imageUrl'].toString();

      int pn = phone.length;
      setState(() {
        UserDetailsModel.firebaseUsersPhone
            .add(phone.substring(pn - kCountryNumberLength));
        UserDetailsModel.firebaseUsersDp.add(dp);
      });
    }
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
      onClose: () {
        print('value');
        Provider.of<BottomNavProvider>(context, listen: false)
            .changeNavStatus();
      },
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
        Provider.of<BottomNavProvider>(context, listen: false)
            .changeNavStatus();

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
  }

  List<Images> cards = [];

  @override
  void initState() {
    super.initState();
    getData();
    getImageData();
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    changeData(_choice);

    print('valentine ${valentine.length}');
    print('anniversary ${anniversary.length}');
    print('birthday ${birthday.length}');
    print('holiday ${holiday.length}');
    print('love ${love.length}');
    print('friend ${friend.length}');

    Size size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Container(
        color: kPrimaryColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: LikeuAppbar(),
            ),
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          WillPopScope(
                            onWillPop: () {
                              print('Pressed');
                              Provider.of<BottomNavProvider>(context,
                                      listen: false)
                                  .changeNavStatus();
                              return Future.value(true);
                            },
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
                                  Provider.of<BottomNavProvider>(context,
                                          listen: false)
                                      .changeNavStatus();

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
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        height: size.height * 0.45,
                        width: 368,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kPrimaryColor,
                        ),
                        child: (valentine.isEmpty ||
                                holiday.isEmpty ||
                                birthday.isEmpty ||
                                anniversary.isEmpty ||
                                all.isEmpty)
                            ? CircularProgressIndicator(color: Colors.white)
                            : Stack(children: cards),
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 48,
                        width: 223.5,
                        child: GradientButton(
                          onPressed: () async {
                            if (_choice == 0 && _index == 0) {
                              Fluttertoast.showToast(
                                  msg: 'Please select another category');
                              return;
                            }
                            if (_index == -1) {
                              Fluttertoast.showToast(
                                  msg: 'Please select another category');
                              return;
                            }
                            if (!showSpinner) {
                              setState(() {
                                showSpinner = true;
                              });
                              await checkPermissionPhoneLogs();
                              setState(() {
                                showSpinner = false;
                              });
                            }
                          },
                          child: const Text(
                            "Send postcard",
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
      ),
    );
  }
}

class Images extends StatefulWidget {
  const Images({Key? key, required this.imageLink}) : super(key: key);

  final String imageLink;

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  int _choice2 = 0;
  List<Text> androidList = [
    Text("Set wallpaper for Home screen", style: kBottomText),
    Text("Set wallpaper for Lock screen", style: kBottomText),
    Text("Save image to gallery", style: kBottomText),
  ];

  List<Text> iosList = [Text("Save image to gallery", style: kBottomText)];

  _openItemPickerForDownload(BuildContext context) {
    BottomPicker(
      items: Platform.isAndroid ? androidList : iosList,
      onClose: () {
        print('value');
        Provider.of<BottomNavProvider>(context, listen: false)
            .changeNavStatus();
      },
      selectedItemIndex: _choice2,
      title: 'Choose something',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
      ),
      backgroundColor: Color(0xFF7A3496),
      bottomPickerTheme: BOTTOM_PICKER_THEME.plumPlate,
      onSubmit: (index) async {
        Provider.of<BottomNavProvider>(context, listen: false)
            .changeNavStatus();

        print('index $index');
        setState(() {
          _choice2 = index;
        });
        if (_choice2 == 0) {
          await setWallpaper(WallpaperManager.HOME_SCREEN);
        } else if (_choice2 == 1) {
          await setWallpaper(WallpaperManager.LOCK_SCREEN);
        } else {
          await _checkStoragePermission();
        }
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Swipable(
      child: InkWell(
        onTap: () async {
          Provider.of<BottomNavProvider>(context, listen: false)
              .changeNavStatus();
          _openItemPickerForDownload(context);
        },
        onLongPress: () async {
          print('long');
          Provider.of<BottomNavProvider>(context, listen: false)
              .changeNavStatus();
          _openItemPickerForDownload(context);
        },
        child: Container(
          alignment: Alignment.center,
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
      ),
      onSwipeEnd: (offSet, value) {
        // print(_index);

        setState(() {
          _index -= 1;
        });
        print('Index $_index');
        if (_index == -1) {
          Fluttertoast.showToast(msg: 'Please select another category');
        }
      },
    );
  }

  Future<void> _checkStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      await _save();
    } else {
      await Permission.contacts.request();
      Fluttertoast.showToast(
        msg: 'Provide storage permission to download images.',
      );
    }
  }

  _save() async {
    var response = await Dio().get(widget.imageLink,
        options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "likeu",
    );

    print(result['isSuccess']);
    if (result['isSuccess']) {
      Fluttertoast.showToast(msg: 'Image saved to gallery successfully');
    } else {
      Fluttertoast.showToast(msg: "Couldn't download the image");
    }
  }

  Future<void> setWallpaper(int locations) async {
    try {
      String url = widget.imageLink;
      int location = locations;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      print(result);

      if (result) {
        Fluttertoast.showToast(msg: 'Wallpaper updated successfully');
      }
    } on PlatformException {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }
}
