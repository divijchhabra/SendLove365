import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:temp/screens/onboarding_screen.dart';
import 'package:temp/services/get_user_data.dart';

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
    _navigateToOnBoarding();
  }

  _navigateToOnBoarding() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    if (user == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OnBoarding()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const GetUserData()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        'assets/Splash Screen-1.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
