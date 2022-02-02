// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:temp/screens/new_send_gift_screen.dart';
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
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/components/likeu_appbar.dart';
import 'package:temp/constants.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:temp/providers/bottom_nav_provider.dart';
import 'package:temp/screens/send_image_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

int _index = 0;
int _choice = 0;

List<Images> cards = [];

class _HomeScreenState extends State<HomeScreen> {
  Future<void> checkPermissionPhoneLogs(int ind) async {
    if (Platform.isIOS
        ? await Permission.contacts.request().isGranted
        : await Permission.phone.request().isGranted &&
            await Permission.contacts.request().isGranted) {
      await getContacts();
      // print('Hello ${contacts.length}');
      print('_index');
      print(ind);

      pushNewScreen(
        context,
        screen: SendImageScreen(
          contacts: contacts,
          imageUrl: _choice == 0
              ? PostCards.allPostCard[ind]
              : _choice == 1
                  ? PostCards.valentinePostCard[ind]
                  : _choice == 2
                      ? PostCards.anniversaryPostCard[ind]
                      : _choice == 3
                          ? PostCards.birthdayPostCard[ind]
                          : _choice == 4
                              ? PostCards.holidayPostCard[ind]
                              : _choice == 5
                                  ? PostCards.lovePostCard[ind]
                                  : PostCards.friendPostCard[ind],
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
        Text("All Postcards", style: kBottomText),
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
      title: 'Choose a category',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.white,
      ),
      iconColor: Colors.black,
      buttonSingleColor: Colors.white,
      backgroundColor: Color(0xFF7A3496),
      bottomPickerTheme: BOTTOM_PICKER_THEME.plumPlate,
      onSubmit: (index) {
        Provider.of<BottomNavProvider>(context, listen: false)
            .changeNavStatus();

        print('indexSubmit $index');
        setState(() {
          _choice = index;
          _index = changeData(index);
        });
      },
    ).show(context);
  }

  int changeData(int ch) {
    switch (ch) {
      case 0:
        {
          cards.clear();
          for (var image in PostCards.allPostCard) {
            cards.add(Images(imageLink: image));
          }
          setState(() {});
        }
        break;
      case 1:
        {
          cards.clear();
          for (var image in PostCards.valentinePostCard) {
            cards.add(Images(imageLink: image));
          }
          setState(() {});
        }
        break;
      case 2:
        {
          cards.clear();
          for (var image in PostCards.anniversaryPostCard) {
            cards.add(Images(imageLink: image));
          }
          setState(() {});
        }
        break;
      case 3:
        {
          cards.clear();
          for (var image in PostCards.birthdayPostCard) {
            cards.add(Images(imageLink: image));
          }
          setState(() {});
        }
        break;
      case 4:
        {
          cards.clear();
          for (var image in PostCards.holidayPostCard) {
            cards.add(Images(imageLink: image));
          }
          setState(() {});
        }
        break;
      case 5:
        {
          cards.clear();
          for (var image in PostCards.lovePostCard) {
            cards.add(Images(imageLink: image));
          }
          setState(() {});
        }
        break;
      case 6:
        {
          cards.clear();
          for (var image in PostCards.friendPostCard) {
            cards.add(Images(imageLink: image));
          }
          setState(() {});
        }
        break;
    }
    return cards.length - 1;
  }

  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    getData();

    _index = PostCards.allPostCard.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    _index = changeData(_choice);

    print('_index');
    print(_index);
    print(cards.length);

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
                          // InkWell(
                          //   onTap: (){
                          //     _index += 1;
                          //     setState(() {
                          //
                          //     });
                          //   },
                          //   child: Container(
                          //     height: 30,
                          //     width: 30,
                          //     color: Colors.green,
                          //   ),
                          // ),

                          WillPopScope(
                            onWillPop: () {
                              print('Pressed');
                              Provider.of<BottomNavProvider>(context,
                                      listen: false)
                                  .changeNavStatus();
                              return Future.value(true);
                            },
                            child: GestureDetector(
                              onTap: () {
                                Provider.of<BottomNavProvider>(context,
                                        listen: false)
                                    .changeNavStatus();

                                _openSimpleItemPicker(context);
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: gradient1,
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: kPrimaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        _choice == 0
                                            ? 'All Postcards'
                                            : _choice == 1
                                                ? 'Valentine'
                                                : _choice == 2
                                                    ? 'Anniversary'
                                                    : _choice == 3
                                                        ? 'Birthdays'
                                                        : _choice == 4
                                                            ? 'Holidays'
                                                            : _choice == 5
                                                                ? 'Love'
                                                                : _choice == 6
                                                                    ? 'Friends'
                                                                    : '',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.menu_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.center,
                        height: 384,
                        width: 216,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kPrimaryColor,
                        ),
                        child: Stack(children: cards),
                      ),
                      const SizedBox(height: 20),
                      GradientButton(
                        width: 223.5,
                        onPressed: () async {
                          print("onTap $_index");
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
                            await checkPermissionPhoneLogs(_index);
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        },
                        child: const Text(
                          "Send a postcard",
                          style: kButtonTextStyle,
                        ),
                        gradient: gradient1,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 240,
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
                          onPressed: () async {
                            // await launch('https://likeu.app/');

                            pushNewScreen(
                              context,
                              screen: NewSendGiftScreen(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          icon: const Icon(Icons.card_giftcard),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: const Text(
                              "Send a gift",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
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
      iconColor: Colors.black,
      buttonSingleColor: Colors.white,
      bottomPickerTheme: BOTTOM_PICKER_THEME.plumPlate,
      onSubmit: (index) async {
        Provider.of<BottomNavProvider>(context, listen: false)
            .changeNavStatus();

        print('index $index');
        setState(() {
          _choice2 = index;
        });
        if (_choice2 == 0) {
          if (Platform.isAndroid) {
            await setWallpaper(WallpaperManager.HOME_SCREEN);
          } else {
            await _checkStoragePermission();
          }
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
        // onTap: () async {
        //   Provider.of<BottomNavProvider>(context, listen: false)
        //       .changeNavStatus();
        //   _openItemPickerForDownload(context);
        // },
        // onLongPress: () async {
        //   print('long');
        //   Provider.of<BottomNavProvider>(context, listen: false)
        //       .changeNavStatus();
        //   _openItemPickerForDownload(context);
        // },
        child: Container(
          alignment: Alignment.center,
          height: 384,
          width: 216,
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
        AssetsAudioPlayer.defaultVolume;
        AssetsAudioPlayer.newPlayer().open(Audio("assets/home.mp4"),
            showNotification: false, volume: 0.2);
        print('Index $_index');
        if (_index == -1) {
          Fluttertoast.showToast(msg: 'Please select another category');
        }
        print('Index $_index');
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
