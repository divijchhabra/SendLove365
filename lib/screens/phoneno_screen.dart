// ignore_for_file: prefer_const_constructors

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/helpers/validators.dart';
import 'package:temp/screens/otp_screen.dart';

class PhoneNo extends StatefulWidget {
  const PhoneNo({Key? key}) : super(key: key);

  @override
  _PhoneNoState createState() => _PhoneNoState();
}

class _PhoneNoState extends State<PhoneNo> {
  TextEditingController mobileController = TextEditingController();
  String dialCode = '+91';

  Future<void> checkPermissionPhoneLogs() async {
    if (await Permission.phone.request().isGranted &&
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
      await Permission.phone.request();

      await Permission.contacts.request();

      Fluttertoast.showToast(
        msg: 'Provide Phone permission to make a call and view logs.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
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
                      "Phone Number",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                  height: 51,
                  width: 326,
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (c) {
                          print(c.dialCode);
                          dialCode = c.dialCode!;
                        },

                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'IN',
                        favorite: const ['+91', 'IN'],
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: "Phone Number",
                          ),
                          controller: mobileController,
                          onSaved: (mobile) {
                            mobileController.value =
                                mobileController.value.copyWith(text: mobile);
                          },
                          validator: phoneValidator,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 48,
                  width: 168.5,
                  child: GradientButton(
                      onPressed: () async {
                        await checkPermissionPhoneLogs();
                        print('Mobile:- ${mobileController.text}');
                      },
                      child: const Text(
                        "Next",
                        style: kButtonTextStyle,
                      ),
                      gradient: gradient1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
