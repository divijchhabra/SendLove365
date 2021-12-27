import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/phoneno_screen.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int activeIndex = 0;
  final urlImages = [
    'assets/2 screen postcards 10 sec.gif',
    'assets/3 screen gifts 10 sec.gif',
    'assets/4 Screen reminders Jpeg.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Image.asset(
          //       'assets/Send LOve Icon envelope.png',
          //       height: 68,
          //       width: 68,
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => const PhoneNo()),
          //         );
          //       },
          //       child: const Text(
          //         "SKIP",
          //         style: TextStyle(color: Colors.black, fontSize: 20),
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height *0.93,
            child: PageView.builder(
              itemCount: 3,
                onPageChanged: (int val){
                  setState(() => activeIndex = val);
                },

                itemBuilder: (c,i ) {
              return Container(

                child: Image.asset(
                  urlImages[i],
                  fit: BoxFit.fitWidth,

                ),
              );
            }),
          ),
          Container(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: buildIndicator(),
                  ),
                  activeIndex==2?
                  GestureDetector(
                    behavior : HitTestBehavior.translucent,
                    onTap: (){
                      print('dc');
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const PhoneNo()));
                      // Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => const PhoneNo()));
                    },
                    child: Container(
                      height: 40,
                      width: 40,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Icons.arrow_forward_ios_outlined,color: kPrimaryColor,),
                    ),
                  ) : Container(
                    height: 40,
                    width: 40,
                  )
                ],
              ),
            ),
          ),
          // const SizedBox(height: 50),
          // Column(
          //   children: [
          //     Container(
          //       width: MediaQuery.of(context).size.width,
          //       child: Center(
          //         child: CarouselSlider.builder(
          //           itemCount: urlImages.length,
          //           itemBuilder: (context, index, realIndex) {
          //             final urlImage = urlImages[index];
          //
          //             return buildImage(urlImage, index);
          //           },
          //           options: CarouselOptions(
          //             height: MediaQuery.of(context).size.height * 0.7,
          //             // viewportFraction: 1,
          //             // aspectRatio: 1,
          //             autoPlay: false,
          //             autoPlayAnimationDuration: const Duration(seconds: 10),
          //             enlargeCenterPage: false,
          //             onPageChanged: (index, reason) =>
          //                 setState(() => activeIndex = index),
          //           ),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(height: 40),
          //     // buildIndicator(),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildImage(String urlImage, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Image.asset(
          urlImage,
          fit: BoxFit.cover,
          height: 1000,
          width: 4000,
        ),
      );


  Widget buildIndicator() => Container(
    height: 30,
    child: AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: urlImages.length,
          effect: const ExpandingDotsEffect(
            dotWidth: 10,
            dotHeight: 10,
            dotColor: Colors.white,
            activeDotColor: Colors.white,
          ),
        ),
  );
}
