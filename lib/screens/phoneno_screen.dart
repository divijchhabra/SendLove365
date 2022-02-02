// ignore_for_file: prefer_const_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/helpers/validators.dart';
import 'package:temp/providers/check_box_provider.dart';
import 'package:temp/screens/otp_screen.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'package:flutter/rendering.dart';
class PhoneNo extends StatefulWidget {
  const PhoneNo({Key? key}) : super(key: key);

  @override
  _PhoneNoState createState() => _PhoneNoState();
}

class _PhoneNoState extends State<PhoneNo> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  String dialCode = '+1';
  ScrollController _scrollController = ScrollController();

  Future<void> checkPermissionPhoneLogs() async {
    if (_formFieldKey.currentState!.validate()) {
      if (Platform.isIOS
          ? await Permission.contacts.request().isGranted
          : await Permission.phone.request().isGranted &&
              await Permission.contacts.request().isGranted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: 'phone'),
            builder: (context) => OtpScreen(
              phoneNo: dialCode + mobileController.text,
            ),
          ),
        );
      } else {
        if (Platform.isIOS) {
          await Permission.contacts.request();
        } else {
          await Permission.phone.request();
          await Permission.contacts.request();
        }

        Fluttertoast.showToast(
          msg: 'Provide Phone permission to make a call and view logs.',
        );
      }
    }
  }
  // TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  @override
  Widget build(BuildContext context) {
    bool isChecked = Provider.of<CheckBoxProvider>(context).checked;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: SizedBox(
              height: MediaQuery.of(context).size.height ,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  height: MediaQuery.of(context).size.height ,
                  child: Column(
                    children: [
                      Column(
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
                            children: const [
                              Text(
                                "Phone Number",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(height: 90),
                          const Text(
                            "Please enter your phone number to get started.",
                            textAlign: TextAlign.center,
                            style: kTextStyle,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: 326,
                            child: Form(
                              key: _formFieldKey,
                              child: Row(
                                children: [
                                  CountryCodePicker(
                                    onChanged: (c) {
                                      // print(c.dialCode);
                                      dialCode = c.dialCode!;
                                      setState(() {});
                                    },
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: 'US',
                                    favorite: const ['+1', 'US'],
                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                    // optional. Shows only country name and flag when popup is closed.
                                    showOnlyCountryWhenClosed: false,
                                    // optional. aligns the flag and the Text left
                                    alignLeft: false,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      onTap: (){
                                        _scrollController.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.easeIn);


                                      },
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 10.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        labelText: "Phone Number",
                                      ),
                                      controller: mobileController,
                                      onSaved: (mobile) {
                                        mobileController.value = mobileController
                                            .value
                                            .copyWith(text: mobile);
                                      },
                                      validator: phoneValidator,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // const SizedBox(height: 30),

                        ],
                      ),


                      SizedBox(height : 40),
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

                            // Expanded(
                            //   child: Column(
                            //     children: [
                            //       SizedBox(
                            //         height : 55,
                            //         child: Row(
                            //           children: [
                            //             Expanded(
                            //               child: Text(
                            //                 'I agree to Likeu’s',
                            //                 style: TextStyle(color: kSecondaryColor),
                            //               ),
                            //             ),
                            //             InkWell(
                            //               onTap: () async {
                            //                 if (!await launch(
                            //                     'https://www.iubenda.com/terms-and-conditions/98376270')) {
                            //                   Fluttertoast.showToast(
                            //                       msg: 'Something went wrong');
                            //                 }
                            //               },
                            //               child: Flexible(
                            //                 child: Text(
                            //                   ' Terms and Conditions',
                            //                   style: TextStyle(color: kSecondaryColor,
                            //                       fontWeight: FontWeight.bold,
                            //                       decoration: TextDecoration.underline),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //
                            //       Row(
                            //         children: [
                            //           Text(
                            //             ' and',
                            //             style: TextStyle(color: kSecondaryColor),
                            //           ),
                            //           InkWell(
                            //             onTap: () async {
                            //               if (!await launch(
                            //                   'https://www.iubenda.com/privacy-policy/98376270')) {
                            //                 Fluttertoast.showToast(
                            //                     msg: 'Something went wrong');
                            //               }
                            //             },
                            //             child: Text(
                            //               ' Privacy Policy',
                            //               style: TextStyle(color: kSecondaryColor,
                            //                   fontWeight: FontWeight.bold,
                            //              decoration: TextDecoration.underline),
                            //             ),
                            //           ),
                            //
                            //         ],
                            //       ),
                            //
                            //     ],
                            //   ),
                            // ),

                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: 'I agree to Likeu\'s ',
                                  style: TextStyle(color: kSecondaryColor),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Terms and Conditions',

                                  style: TextStyle(color: kSecondaryColor,
                                                      fontWeight: FontWeight.bold,
                                                 decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = ()  async{
                                        if (!await launch(
                                                          'https://www.iubenda.com/privacy-policy/98376270')) {
                                                        Fluttertoast.showToast(
                                                            msg: 'Something went wrong');
                                                      }
                                      },
                                    ),

                                    TextSpan(
                                      text: ' and ',
                                      style: TextStyle(color: kSecondaryColor,),),

                                    TextSpan(
                                        text: 'Privacy Policy',
                                      style: TextStyle(color: kSecondaryColor,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = ()  async{
                                            if (!await launch(
                                                              'https://www.iubenda.com/privacy-policy/98376270')) {
                                                            Fluttertoast.showToast(
                                                                msg: 'Something went wrong');
                                                          }
                                          }),
                                  ],
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      GradientButton(
                          width: 168.5,
                          onPressed: () async {
                            if (isChecked) {
                              await checkPermissionPhoneLogs();
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
                          child: const Text(
                            "Next",
                            style: kButtonTextStyle,
                          ),
                          gradient: gradient1),
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
