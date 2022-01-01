import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:temp/constants.dart';
import 'package:temp/screens/chat/chat_screen.dart';
import 'package:temp/screens/home_screen.dart';
import 'package:temp/screens/reminder_screen.dart';
import 'package:temp/screens/settings_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  //int _currentIndex = 0;
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        activeColorPrimary: kPrimaryColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.chat_rounded),
        title: ("Chat"),
        activeColorPrimary: kPrimaryColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.notifications_active),
        title: ("Reminders"),
        activeColorPrimary: kPrimaryColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: kPrimaryColor,
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const ChatScreen(),
    const ReminderScreen(),
    const SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _widgetOptions,
        items: _navBarsItems(),
        // popAllScreensOnTapOfSelectedTab: true,
        // popActionScreens: PopActionScreensType.all,

        confineInSafeArea: false,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: false,

        //backgroundColor: kPrimaryColor,
        decoration: NavBarDecoration(
          adjustScreenBottomPaddingOnCurve: true,
          gradient: gradient2,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
            bottom: Radius.circular(0),
          ),
          colorBehindNavBar: kPrimaryColor,
        ),
        navBarStyle: NavBarStyle.style10,
      ),
    );
  }
}
