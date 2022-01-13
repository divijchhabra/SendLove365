// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/helpers/validators.dart';
import 'package:temp/screens/profile_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:temp/services/get_user_data.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.phoneNo}) : super(key: key);
  final String phoneNo;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationCode;

  bool showSpinner = false;

  String? otp;

  late Timer _timer;
  int _start = 45;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    startTimer();
    _verifyPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo1.jpg',
                        height: 68,
                        width: 68,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        "Enter Verification Code",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 90),
                  const Text(
                    "We have sent an OTP code to your phone number.",
                    textAlign: TextAlign.center,
                    style: kTextStyle,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  PinCodeTextField(
                    appContext: context,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    length: 6,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(10),
                      fieldHeight: 54,
                      fieldWidth: 50,
                      inactiveFillColor: kSecondaryColor,
                      activeColor: kPrimaryColor,
                      activeFillColor: kPrimaryColor,
                      inactiveColor: kSecondaryColor,
                      selectedColor: kPrimaryColor,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    onChanged: (value) {
                      setState(() {
                        otp = value;
                      });
                    },
                    validator: otpValidator,
                  ),
                  (_start != 0) ? Text('00:$_start') : Text('00:00'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      await _verifyPhone();
                    },
                    child: const Text("Send Again"),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    width: 168.5,
                    child: GradientButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          // print('otp1 $_verificationCode');
                          // print('otp2 $otp');
                          try {
                            await _auth
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId: _verificationCode!,
                                        smsCode: otp!))
                                .then((value) async {
                              // print('User Logged In');
                              if (value.additionalUserInfo!.isNewUser) {
                                // print('New User');
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(phoneNo: widget.phoneNo),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                // print('Old User');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GetUserData(),
                                  ),
                                );
                              }
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            FocusScope.of(context).unfocus();
                            Fluttertoast.showToast(msg: 'Invalid Otp');
                          }
                        },
                        child: const Text("Submit", style: kButtonTextStyle),
                        gradient: gradient1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    setState(() {
      showSpinner = true;
    });

    await _auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNo,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential).then((value) async {
            // print('User Logged In');
            if (value.additionalUserInfo!.isNewUser) {
              // print('New User');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                            phoneNo: widget.phoneNo,
                          )),
                  (route) => false);
            } else {
              // print('Old User');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GetUserData(),
                ),
              );
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            showSpinner = false;
          });
          print(e.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${e.message}",
                style: TextStyle(fontSize: 16),
              ),
            ),
          );
        },
        codeSent: (String verficationID, int? resendToken) {
          Fluttertoast.showToast(msg: 'OTP Sent successfully');
          setState(() {
            _verificationCode = verficationID;
          });
          // print(verficationID);
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
    setState(() {
      showSpinner = false;
    });
  }
}
