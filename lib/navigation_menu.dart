import 'package:flutter/material.dart';
import 'package:swd392/Home/homepage.dart';
import 'package:swd392/Notification/notification.dart';
import 'package:swd392/Profile/edit_profile.dart';
import 'package:swd392/Profile/profile.dart';
import 'package:swd392/Search/search_ticket.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          )
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          indicatorColor: Colors.orange,
          height: 80,
          elevation: 0,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home, 
                size: 30),
              selectedIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: "Trang chủ",
            ),
            NavigationDestination(
                icon: Icon(
                  Icons.qr_code,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.qr_code,
                  color: Colors.white,
                ),
                label: "Tra cứu"),
            NavigationDestination(
                icon: Icon(
                  Icons.notifications,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                label: "Thông báo"),
            NavigationDestination(
                icon: Icon(
                  Icons.person,
                  size: 30,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: "Tài khoản"),
          ],
        ),
      ),
      body: Center(
        child: _getSelectedPage(_selectedIndex),
      ),
    );
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return MyHomePage();
      case 1:
        return SearchTicketPage();
      case 2:
        return EditProfilePage();
      case 3:
        return ProfilePage();
      default:
        return const Text('Trang chủ');
    }
  }
}
