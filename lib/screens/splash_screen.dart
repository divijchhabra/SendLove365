import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/onboarding_screen.dart';
import 'package:temp/screens/video_splash.dart';
import 'package:temp/services/get_user_data.dart';
import 'package:assets_audio_player/assets_audio_player.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    init();
    _navigateToOnBoarding();
  }

  init(){
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/blank.mp3"),

      showNotification: false,
    );
  }

  _navigateToOnBoarding() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const VideoSplash()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const GetUserData()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //   gradient: gradient1
        // ),
        child: Image.asset(
          'assets/splash.png',
          // width: 200,
          // height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
