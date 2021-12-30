// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SendAGift extends StatefulWidget {
  const SendAGift({Key? key}) : super(key: key);

  @override
  _SendAGiftState createState() => _SendAGiftState();
}

class _SendAGiftState extends State<SendAGift> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Send Love 365 banner cat.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 500,
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: const Text(
                          "Select A Gift",
                          style: TextStyle(fontSize: 23),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          if (!await launch("https://sendlove365.co/"))
                            throw 'Could not launch';
                        },
                        child: Image.asset(
                          'assets/Mask Group 1.png',
                          height: 321,
                          width: 294,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (!await launch("https://sendlove365.co/"))
                            throw 'Could not launch';
                        },
                        child: Image.asset(
                          'assets/Mask Group 1.png',
                          height: 321,
                          width: 294,
                        ),
                      ),
                    ],
                  ),
                  width: 294,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  width: 223.5,
                  child: GradientButton(
                      onPressed: () {},
                      child: const Text(
                        "Send A Gift",
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
