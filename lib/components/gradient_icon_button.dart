import 'package:flutter/material.dart';

class GradientIconButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Gradient gradient;
  final Widget icon;
  const GradientIconButton(
      {required this.onPressed,
      required this.child,
      required this.gradient,
      required this.icon,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon,
      onPressed: onPressed,
      label: child,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        padding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),

      // style: Ink(
      //   width: 300,
      //   decoration: BoxDecoration(
      //     gradient: gradient,
      //     borderRadius: BorderRadius.circular(10.0),
      //   ),
      //   child: Container(
      //       constraints: const BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
      //       alignment: Alignment.center,
      //       child: child),
      // ),
      // splashColor: Colors.black12,
      // padding: const EdgeInsets.all(0),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(32.0),
      // ),
    );
  }
}
