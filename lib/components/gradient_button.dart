import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Gradient gradient;
  const GradientButton(
      {Key? key,
      required this.onPressed,
      required this.child,
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
        child: Container(
            constraints: const BoxConstraints(maxWidth: 290.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: child),
      ),
      splashColor: Colors.black12,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
    );
  }
}
