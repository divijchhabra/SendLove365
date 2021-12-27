import 'package:flutter/material.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/profile_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? pinValue;

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
                      "Enter Verification Code",
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                  length: 5,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 64,
                    fieldWidth: 62,
                    inactiveFillColor: kSecondaryColor,
                    activeColor: kPrimaryColor,
                    activeFillColor: kPrimaryColor,
                    inactiveColor: kSecondaryColor,
                    selectedColor: kPrimaryColor,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  onChanged: (value) {
                    setState(() {
                      pinValue = value;
                    });
                  },
                ),
                const Text("00:44"),
                const SizedBox(height: 8),
                TextButton(onPressed: () {}, child: const Text("Send Again")),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  width: 168.5,
                  child: GradientButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        );
                      },
                      child: const Text(
                        "Submit",
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
