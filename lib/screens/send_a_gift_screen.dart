// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/components/likeu_appbar.dart';
import 'package:temp/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SendAGift extends StatefulWidget {
  const SendAGift({Key? key}) : super(key: key);

  @override
  _SendAGiftState createState() => _SendAGiftState();
}

class _SendAGiftState extends State<SendAGift> {
  CollectionReference gifts = FirebaseFirestore.instance.collection('gifts');

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [


                          // SizedBox(
                          //   // color: Colors.red,
                          //   height: 500,
                          //   child: PageView(
                          //     onPageChanged: (value) {
                          //       // print('value');
                          //       // print(value);
                          //     },
                          //     scrollDirection: Axis.vertical,
                          //     children: snapshot.data!.docs.map(
                          //       (DocumentSnapshot document) {
                          //         data = document.data()!;
                          //         // print(document.toString());
                          //         // print('data');
                          //         // print(data['imageSrc']);
                          //         String imageSrc = data['imageSrc'];
                          //
                          //         return
                          //       },
                          //     ).toList(),
                          //   ),
                          //   width: 400,
                          // ),

                          Text('Now is the perfect time to send a thoughtful gift.',
                            textAlign : TextAlign.center , style: TextStyle(
                            fontSize: 20
                          ),),
                          SizedBox(height: 20,),
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (c,i){
                                 var docs =  snapshot.data!.docs;

                               return Column(
                                 children: [
                                   Row(
                                     children: [
                                       SizedBox(width: 15,),
                                       Align(
                                         alignment : Alignment.centerLeft,
                                         child: Text(docs[i]['name'],
                                           textAlign: TextAlign.left,
                                           style: TextStyle(
                                           fontSize: 16,
                                           fontWeight: FontWeight.bold
                                         ),),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: 10,),
                                   InkWell(
                                    onTap: () async {
                                      if (!await launch(docs[i]['imageSrc'])) {
                                        throw 'Could not launch';
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
                                      child: Image(
                                        height: 300,
                                        width: 400,
                                        image: NetworkImage(docs[i]['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                              ),
                                   SizedBox(height: 20,),

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
