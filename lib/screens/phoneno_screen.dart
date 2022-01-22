// ignore_for_file: prefer_const_constructors
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

class PhoneNo extends StatefulWidget {
  const PhoneNo({Key? key}) : super(key: key);

  @override
  _PhoneNoState createState() => _PhoneNoState();
}

class _PhoneNoState extends State<PhoneNo> {
  final GlobalKey<FormState> _formFieldKey = GlobalKey();

  TextEditingController mobileController = TextEditingController();
  String dialCode = '+91';

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

  @override
  Widget build(BuildContext context) {
    bool isChecked = Provider.of<CheckBoxProvider>(context).checked;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    setState(() {

                                    });
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
                        SizedBox(
                          height: 48,
                          width: 168.5,
                          child: GradientButton(
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
                        ),
                      ],
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
