import 'package:flutter/material.dart';

class LikeuAppbar extends StatelessWidget {
  const LikeuAppbar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/homeAppbar.jpg'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
