// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:temp/components/bottom_nav.dart';
import 'package:temp/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NewSendGiftScreen extends StatefulWidget {
  NewSendGiftScreen({this.messageSentScreen=false});

  final bool messageSentScreen;

  @override
  _NewSendGiftScreenState createState() => _NewSendGiftScreenState();
}

class _NewSendGiftScreenState extends State<NewSendGiftScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.messageSentScreen? 'assets/bg.png' : 'assets/gradient.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(!widget.messageSentScreen)
                  Column(
                    children: [
                      SizedBox(height: size.height*0.1),
                      Align(
                        alignment: Alignment.center,
                        child: Text('Send a Gift',style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,

                        ),),
                      ),
                      SizedBox(height: size.height * 0.1 ),
                    ],
                  ),
                if(widget.messageSentScreen)
                 SizedBox(height: size.height * 0.3 ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DisplayImage(
                        size: size,
                        image: '3',
                        url: 'https://likeu.app/'),
                    DisplayImage(size: size, image: '11',url : 'https://likeu.app/collections/birthday'),
                    DisplayImage(size: size, image: '6',url: 'https://likeu.app/collections/friends' ,),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DisplayImage(size: size, image: '5',url: 'https://likeu.app/collections/love',),
                    DisplayImage(size: size, image: '2',url: 'https://likeu.app/collections/good-vibes',),
                    DisplayImage(size: size, image: '8',url: 'https://likeu.app/collections/valentines-day',),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DisplayImage(size: size, image: '4',url: 'https://likeu.app/collections/gift-cards',),
                    DisplayImage(size: size, image: '7',url: 'https://likeu.app/collections/guys',),
                    DisplayImage(size: size, image: '1',url: 'https://likeu.app/collections/food',),
                  ],
                ),
                SizedBox(height: 55),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNav(),
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Home',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 55),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayImage extends StatelessWidget {
  const DisplayImage({
    Key? key,
    required this.size,
    required this.image,
    this.url = 'https://likeu.app/collections/valentines-day',
  }) : super(key: key);

  final Size size;
  final String image, url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launch(url);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image(
          image: AssetImage('assets/$image.png'),
          width: size.width * 0.27,
          height: size.width * 0.27,
        ),
      ),
    );
  }
}
