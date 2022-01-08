// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temp/helpers/validators.dart';
import 'package:temp/providers/check_box_provider.dart';
import 'package:temp/services/firebase_upload.dart';
import 'package:temp/services/get_user_data.dart';
import 'package:temp/services/store_user_details.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.phoneNo}) : super(key: key);
  final String phoneNo;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  // image source
  File? _image;

  // upload task
  UploadTask? task;

  String? urlDownload;

  bool showSpinner = false;
  late TextEditingController userNameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    userNameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    userNameController = TextEditingController();
    emailController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = Provider.of<CheckBoxProvider>(context).checked;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formFieldKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/Send LOve Icon envelope.png',
                              height: 68,
                              width: 68,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Text(
                              "Setup Profile",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: _image == null
                              ? Image.asset(
                                  'assets/profile.png',
                                  height: 107.91,
                                  width: 107.91,
                                )
                              : Image.file(
                                  _image!,
                                  // alignment: Alignment.center,
                                  height: 107.91,
                                  width: 107.91,
                                  // fit: BoxFit.fitWidth,
                                ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          // height: 51,
                          width: 326,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Username",
                            ),
                            controller: userNameController,
                            onSaved: (userName) {
                              userNameController.value = userNameController
                                  .value
                                  .copyWith(text: userName);
                            },
                            validator: userNameValidator,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          // height: 51,
                          width: 326,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 10.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Email",
                            ),
                            controller: emailController,
                            onSaved: (email) {
                              emailController.value =
                                  emailController.value.copyWith(text: email);
                            },
                            validator: emailValidator,
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                if (!await launch(
                                    'https://www.iubenda.com/terms-and-conditions/98376270')) {
                                  Fluttertoast.showToast(
                                      msg: 'Something went wrong');
                                }
                              },
                              child: Text(
                                'Terms and conditions',
                                style: TextStyle(color: kSecondaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                Provider.of<CheckBoxProvider>(context,
                                        listen: false)
                                    .changeCheck();
                              },
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (!await launch(
                                      'https://www.iubenda.com/privacy-policy/98376270')) {
                                    Fluttertoast.showToast(
                                        msg: 'Something went wrong');
                                  }
                                },
                                child: Text(
                                  'I agree to the Likeu Terms of Service and Privacy Policy',
                                  style: TextStyle(color: kSecondaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        width: 168.5,
                        child: GradientButton(
                          onPressed: () async {
                            if (_formFieldKey.currentState!.validate() &&
                                isChecked) {
                              setState(() {
                                showSpinner = true;
                              });
                              await uploadImage();
                              await StoreUserInfo().storeUserDetails(
                                userNameController.text,
                                emailController.text,
                                urlDownload,
                                widget.phoneNo,
                                DateTime.now().toUtc().millisecondsSinceEpoch,
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GetUserData()),
                              );
                              setState(() {
                                showSpinner = false;
                              });
                            } else if (!isChecked) {
                              try {
                                Fluttertoast.showToast(
                                    msg:
                                        'Please agree to the terms and conditions');
                              } catch (e, s) {
                                print(s);
                              }
                            }
                          },
                          child: const Text("Next", style: kButtonTextStyle),
                          gradient: gradient1,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
