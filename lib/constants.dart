import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF7A3496);
const kSecondaryColor = Color(0xFFC267E7);
const kTertiaryColor = Color.fromRGBO(100, 34, 126, 0.18);
const kTextColor = Color(0xFF3C4046);

Gradient gradient1 = const LinearGradient(
  colors: [kSecondaryColor, kPrimaryColor],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

Gradient gradient2 = const LinearGradient(
    colors: [kSecondaryColor, kPrimaryColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

final kElevatedButtonStyle = ElevatedButton.styleFrom(
    primary: kPrimaryColor,
    textStyle: const TextStyle(fontSize: 20),
    padding: const EdgeInsets.all(8));

const kTextStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
const kBottomText = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
const kButtonTextStyle = TextStyle(fontSize: 20, color: Color(0xFFFFFFFF));

const kTextFieldDecoration = InputDecoration(
  border: OutlineInputBorder(),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintStyle: TextStyle(color: Colors.black87),
);

const kDefaultPadding = 22.0;

int kCountryNumberLength = 10; // Length of number in specific country
