import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temp/providers/bottom_nav_provider.dart';
import 'package:temp/providers/check_box_provider.dart';
import 'package:temp/screens/profile_screen.dart';
import 'package:temp/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => BottomNavProvider()),
    ChangeNotifierProvider(create: (_) => CheckBoxProvider()),
  ], child: const MyApp()));
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
