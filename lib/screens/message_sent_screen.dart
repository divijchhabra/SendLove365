// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/send_a_gift_screen.dart';

class MessageSent extends StatefulWidget {
  const MessageSent({Key? key}) : super(key: key);

  @override
  _MessageSentState createState() => _MessageSentState();
}

class _MessageSentState extends State<MessageSent> {
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
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(70, 20, 70, 0),
                  child: Text(
                    "Your message has been sent!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Now is the perfect time to send a thoughtful gift.",
                  style: TextStyle(fontSize: 19),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(

                  child: ListView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Image.asset(
                        'assets/Mask Group 1.png',
                        height: 321,
                        width: 294,
                      ),
                      Image.asset(
                        'assets/Mask Group 1.png',
                        height: 421,
                        width: 394,
                      )
                    ],
                  ),
                  height: 450,
                  width: 294,
                ),
                const SizedBox(height: 20),
                // SizedBox(
                //   height: 48,
                //   width: 223.5,
                //   child: GradientButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (_) => const SendAGift(),
                //         ),
                //       );
                //     },
                //     child: const Text(
                //       "Send A Gift",
                //       style: kButtonTextStyle,
                //     ),
                //     gradient: gradient1,
                //   ),
                // ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  width: 223.5,
                  child: GradientButton(
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: BottomNav(),
                        // withNavBar: true,
                        // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: const Text(
                      "Go to Home",
                      style: kButtonTextStyle,
                    ),
                    gradient: gradient1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
