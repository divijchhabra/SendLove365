// ignore_for_file: prefer_const_constructors
import 'package:temp/services/get_user_data.dart';
import 'package:temp/screens/phoneno_screen.dart';

import 'package:flutter/material.dart';
import 'package:temp/constants.dart';
import 'package:video_player/video_player.dart';

class VideoSplash extends StatefulWidget {
  const VideoSplash({Key? key}) : super(key: key);

  @override
  _VideoSplashState createState() => _VideoSplashState();
}

class _VideoSplashState extends State<VideoSplash> {
  late VideoPlayerController controller;
  Duration ? position;

  bool showArrow=false;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/splashV.mp4')
      ..addListener(() async {
        setState(() {

        });
      })
      ..setLooping(false)
      ..initialize().then((_) => controller.play());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget(controller: controller);
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {

  bool showImage=false;
  getPosition() {
    if (widget.controller.value.position.toString().substring(5, 7)=='16') {
      setState(() {
        showImage =true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.controller.value.position.toString().substring(5, 7));
    if (widget.controller != null && widget.controller.value.isInitialized) {
      return Scaffold(
        body: Stack(
          alignment: Alignment.bottomRight,
          children: [


            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child: buildVideo(context),
            ),

           FutureBuilder(
             future: getPosition(),
             builder: (context,sc) {
               return showImage ?
                        GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PhoneNo(),
                                ),
                              );
                            },
                            child: Image.asset('assets/arrow.png')) : Container();
             }
           ),


          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildVideo(context) => buildVideoPlayer(context);

  Widget buildVideoPlayer(context) => SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: VideoPlayer(widget.controller));
}
