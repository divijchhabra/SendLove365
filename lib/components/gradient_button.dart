import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Gradient gradient;
  final double width;
  const GradientButton(
      {Key? key,
      required this.onPressed,
      required this.child,
        this.width=290,
      required this.gradient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          child: Container(
              constraints:  BoxConstraints(maxWidth: width,),
              alignment: Alignment.center,
              child: Column(
                children: [
                  child,
                ],
              )),
        ),
      ),
      splashColor: Colors.black12,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
    );
  }
}
