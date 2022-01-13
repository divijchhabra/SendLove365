// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:temp/constants.dart';
import 'package:temp/helpers/validators.dart';
import 'package:temp/screens/phoneno_screen.dart';
import 'package:temp/models/user_details_model.dart';
import 'package:flutter/services.dart';
import 'package:temp/services/firebase_upload.dart';
import 'package:path/path.dart' as path;
import 'package:temp/services/store_user_details.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool showSpinner = false;

  // image source
  File? _image;

  // upload task
  UploadTask? task;

  String? urlDownload;

  bool isText = true;

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/logo1.jpg',
                          height: 68,
                          width: 68,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Settings",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryColor,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        await getImage();
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: CircleAvatar(
                        radius: 56,
                        backgroundImage: NetworkImage(
                          UserDetailsModel.imageUrl.toString(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !isText
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Form(
                                child: TextFormField(
                                  controller: nameController,
                                  onSaved: (name) {
                                    nameController.value = nameController.value
                                        .copyWith(text: name);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: "Name",
                                  ),
                                  validator: userNameValidator,
                                ),
                              ),
                            )
                          : Text(UserDetailsModel.name.toString()),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () async {
                          if (!isText) {
                            await StoreUserInfo().updateUserDetails(
                              UserDetailsModel.imageUrl,
                              nameController.text,
                            );
                            setState(() {
                              UserDetailsModel.name = nameController.text;
                            });
                          }

                          setState(() {
                            isText = !isText;
                          });
                        },
                        child: isText
                            ? Icon(Icons.edit)
                            : Icon(Icons.done, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: [
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.headphones,
                            color: kPrimaryColor,
                          ),
                          title: Text("Contact Us"),
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(
                            Icons.info,
                            color: kPrimaryColor,
                          ),
                          title: Text("About Likeu"),
                        ),
                        Divider(),
                        ListTile(
                          onTap: () async {
                            await logOut();
                          },
                          leading: Icon(
                            Icons.logout,
                            color: kPrimaryColor,
                          ),
                          title: Text("Log Out"),
                        ),
                      ],
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

  Future<void> logOut() async {
    setState(() {
      showSpinner = true;
    });
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        FirebaseAuth.instance.signOut().then((value) => {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => PhoneNo(),
                ),
              )
            });
      }
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      Fluttertoast();
    }
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

      await uploadImage();

      await StoreUserInfo()
          .updateUserDetails(urlDownload, UserDetailsModel.name);
      setState(() {
        showSpinner = false;
      });

      UserDetailsModel.imageUrl = urlDownload;
    } on PlatformException catch (e) {
      setState(() {
        showSpinner = false;
      });
      Fluttertoast.showToast(msg: 'Failed to pick image $e');
    }
  }

  // Upload image
  Future uploadImage() async {
    // print('image $_image');
    if (_image == null) return;

    final imageName = path.basename(_image!.path);
    final destination = 'files/$imageName';

    task = FirebaseUpload.uploadFile(destination, _image!);

    if (task == null) return null;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    // print('urlDownload $urlDownload');
  }
}
