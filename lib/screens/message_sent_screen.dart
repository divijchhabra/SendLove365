// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/components/likeu_appbar.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/send_a_gift_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageSent extends StatefulWidget {
  const MessageSent({Key? key}) : super(key: key);

  @override
  _MessageSentState createState() => _MessageSentState();
}

class _MessageSentState extends State<MessageSent> {
  CollectionReference gifts = FirebaseFirestore.instance.collection('gifts');

  @override
  Widget build(BuildContext context) {
    //   Scaffold(
    //   appBar: PreferredSize(
    //     preferredSize: const Size.fromHeight(70),
    //     child: LikeuAppbar(),
    //   ),
    //   body:
    //   SafeArea(
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
    //       child: SingleChildScrollView(
    //         child: Column(
    //           children: [
    //             Row(
    //               children: [],
    //             ),
    //             const Padding(
    //               padding: EdgeInsets.fromLTRB(70, 20, 70, 0),
    //               child: Text(
    //                 "Your message has been sent!",
    //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    //                 textAlign: TextAlign.center,
    //               ),
    //             ),
    //             const SizedBox(height: 8),
    //             const Text(
    //               "Now is the perfect time to send a thoughtful gift.",
    //               style: TextStyle(fontSize: 19),
    //               textAlign: TextAlign.center,
    //             ),
    //             const SizedBox(height: 20),
    //             SizedBox(
    //               child: ListView(
    //                 scrollDirection: Axis.vertical,
    //                 physics: const BouncingScrollPhysics(),
    //                 children: [
    //                   Image.asset(
    //                     'assets/Mask Group 1.png',
    //                     height: 321,
    //                     width: 294,
    //                   ),
    //                   Image.asset(
    //                     'assets/Mask Group 1.png',
    //                     height: 421,
    //                     width: 394,
    //                   )
    //                 ],
    //               ),
    //               height: 450,
    //               width: 294,
    //             ),
    //             const SizedBox(height: 20),
    //             // SizedBox(
    //             //   height: 48,
    //             //   width: 223.5,
    //             //   child: GradientButton(
    //             //     onPressed: () {
    //             //       Navigator.push(
    //             //         context,
    //             //         MaterialPageRoute(
    //             //           builder: (_) => const SendAGift(),
    //             //         ),
    //             //       );
    //             //     },
    //             //     child: const Text(
    //             //       "Send A Gift",
    //             //       style: kButtonTextStyle,
    //             //     ),
    //             //     gradient: gradient1,
    //             //   ),
    //             // ),
    //             const SizedBox(height: 20),
    //             SizedBox(
    //               height: 48,
    //               width: 223.5,
    //               child: GradientButton(
    //                 onPressed: () {
    //                   pushNewScreen(
    //                     context,
    //                     screen: BottomNav(),
    //                     // withNavBar: true,
    //                     // OPTIONAL VALUE. True by default.
    //                     pageTransitionAnimation:
    //                         PageTransitionAnimation.cupertino,
    //                   );
    //                 },
    //                 child: const Text(
    //                   "Go to Home",
    //                   style: kButtonTextStyle,
    //                 ),
    //                 gradient: gradient1,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return StreamBuilder<QuerySnapshot>(
      stream: gifts.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasData) {
          dynamic data;

          return Container(
            color: kPrimaryColor,
            child: SafeArea(
              bottom: false,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(110),
                  child: LikeuAppbar(),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(70, 20, 70, 0),
                            child: Text(
                              "Your message has been sent!",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
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
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (c, i) {
                                  var docs = snapshot.data!.docs;

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              docs[i]['name'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (!await launch(
                                              docs[i]['imageSrc'])) {
                                            throw 'Could not launch';
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0),
                                          child: Image(
                                            height: 300,
                                            width: 400,
                                            image:
                                                NetworkImage(docs[i]['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                }),
                          ),
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
                                gradient: gradient1),
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
        return Container();
      },
    );
  }
}
