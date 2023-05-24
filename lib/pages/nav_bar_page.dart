import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:live_graph_plotter/pages/profile_page.dart';
import 'package:live_graph_plotter/pages/user_home_page.dart';
import 'alert_page.dart';
import 'graph_log.dart';

//import 'package:intl/intl.dart';
class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  _NavBarPageState();

  late String? basecurrentActiveId;
  // String getCurrentDate() {
  //   var now = DateTime.now();
  //   //var formatter = DateFormat(' MMMM d, y');
  //   return formatter.format(now);
  // }

  late double deviceHeight;
  late double deviceWidth;
  int trackHeartStatus = 0;

  int selectedIndex = 0;

  final List<Widget> children = [
    const UserHomePage(),
    const LogsPage(),
    const HealthDataDisplay(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: children[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.redAccent,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search_rounded,
                  text: 'Logs',
                ),
                GButton(
                  icon: LineIcons.bell,
                  text: 'Alerts',
                ),
                GButton(
                  icon: Icons.person_2_outlined,
                  text: 'Profile',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                {
                  setState(() {
                    selectedIndex = index;
                    if (index == 3) {
                      children[index] = const ProfilePage();
                    } else {
                      children[index] = children[index];
                    }
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
