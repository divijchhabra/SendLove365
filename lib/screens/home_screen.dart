import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp/components/gradient_button.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/send_a_gift_screen.dart';
import 'package:temp/screens/send_to_friend_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedItem = 0;
  void _openSimpleItemPicker(BuildContext context) {
    BottomPicker(
      items: const [
        Text("See All"),
        Text("Love"),
        Text("Friends"),
        Text("Holidays"),
        Text("Birthdays")
      ],
      title: 'Choose something',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      //backgroundColor: Colors.yellow.withOpacity(0.6),
      bottomPickerTheme: BOTTOM_PICKER_THEME.plumPlate,
      onSubmit: (index) {
        print(index);
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kSecondaryColor,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Send Love 365 banner cat.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: kPrimaryColor,
                        ),
                        child: IconButton(
                          // alignment: const Alignment(85, 3),
                          onPressed: () {
                            _openSimpleItemPicker(
                              context,
                            );
                          },
                          highlightColor: kPrimaryColor,

                          icon: const Icon(
                            Icons.menu_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: kPrimaryColor,
                    ),
                    height: 350,
                    width: 368,
                  ),
                  const SizedBox(height: 20),
                  // GradientIconButton(
                  //     onPressed: () {},
                  //     child: const Text("Send to friend"),
                  //     gradient: gradient1,
                  //     icon: Icon(Icons.arrow_forward)),
                  SizedBox(
                    height: 48,
                    width: 223.5,
                    child: GradientButton(
                      onPressed: () {
                        pushNewScreen(
                          context,
                          screen: SendToFriend(),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );


                      },
                      child: const Text(
                        "Send to friend",
                        style: kButtonTextStyle,
                      ),
                      gradient: gradient1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    width: 223.5,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: const BorderSide(
                          width: 2,
                          color: kPrimaryColor,
                          style: BorderStyle.solid,
                        ),
                      ),
                      onPressed: () {
                        pushNewScreen(
                          context,
                          screen: SendAGift(),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );

                      },
                      icon: const Icon(Icons.card_giftcard),
                      label: const Text(
                        "Send a gift",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
