import 'package:flutter/material.dart';

import 'package:temp/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF7A3496),
        primarySwatch: Colors.purple,
        fontFamily: 'ComicSansMS3',
      ),
      home: const Splash(),
    );
  }
}
