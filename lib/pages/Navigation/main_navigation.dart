import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:spar/pages/Navigation/home_page.dart';
import 'package:spar/pages/Navigation/search_page.dart';
import 'package:spar/pages/Navigation/orders_page.dart';
import 'package:spar/pages/Navigation/notifications_page.dart';
import 'package:spar/pages/Navigation/profile_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    OrdersPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFFF2F5F7),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFC42348),
          unselectedItemColor: Color(0xFF8195A6),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01, size: 30),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedDocumentAttachment, size: 30),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedNotification01, size: 30),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedUser, size: 30),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
