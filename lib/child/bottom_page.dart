import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safewomen/child/bottom_screens/add_contacts.dart';
import 'package:safewomen/child/bottom_screens/chat_page.dart';
import 'package:safewomen/child/bottom_screens/child_home_page.dart';
import 'package:safewomen/child/bottom_screens/maps_page.dart';
import 'package:safewomen/child/bottom_screens/profile_page.dart';
import 'package:safewomen/child/bottom_screens/review_page.dart';

class BottomPage extends StatefulWidget {
  BottomPage({Key? key}) : super(key: key);

  @override
  State<BottomPage> createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  String home_icon = "assets/svg/home.svg";
  String contact_icon = "assets/svg/contact.svg";
  String profile_icon = "assets/svg/profile.svg";
  String chat_icon = "assets/svg/message.svg";
  String map_icon = "assets/svg/map.svg";
  String review_icon = "assets/svg/star.svg";
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    const AddContactsPage(),
    const MapsPage(),
    ChatPage(),
    const ProfilePage(),
    const ReviewPage(),
  ];
  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 0,
            indicatorColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
            labelTextStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5))),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: NavigationBar(
            // currentIndex: currentIndex,
            // type: BottomNavigationBarType.fixed,
            // onTap: onTapped,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: currentIndex,
            onDestinationSelected: (value) => setState(() {
              this.currentIndex = value;
            }),

            destinations: [
              NavigationDestination(
                label: 'Home',
                icon: SvgPicture.asset(
                  home_icon,
                  height: 30,
                  width: 30,
                ),
              ),
              NavigationDestination(
                label: 'Contacts',
                icon: SvgPicture.asset(
                  contact_icon,
                  height: 30,
                  width: 30,
                ),
              ),
              NavigationDestination(
                label: 'Location',
                icon: SvgPicture.asset(
                  map_icon,
                  height: 30,
                  width: 30,
                ),
              ),
              NavigationDestination(
                label: 'Chats',
                icon: SvgPicture.asset(
                  chat_icon,
                  height: 30,
                  width: 30,
                ),
              ),
              NavigationDestination(
                label: 'Profile',
                icon: SvgPicture.asset(
                  profile_icon,
                  height: 30,
                  width: 30,
                ),
              ),
              NavigationDestination(
                label: 'Reviews',
                icon: SvgPicture.asset(
                  review_icon,
                  height: 30,
                  width: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
