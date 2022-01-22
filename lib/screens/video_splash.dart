// ignore_for_file: prefer_const_constructors

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

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/splashV.mp4')
      ..addListener(() => setState(() {}))
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

class VideoPlayerWidget extends StatelessWidget {
  const VideoPlayerWidget({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    print(controller.value.position.toString().substring(5, 7));
    if (controller != null && controller.value.isInitialized) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child: buildVideo(context),
            )
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
      child: VideoPlayer(controller));
}
