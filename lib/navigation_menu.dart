import 'package:flutter/material.dart';
import 'package:swd392/Home/homepage.dart';
import 'package:swd392/Notification/notification.dart';
import 'package:swd392/Profile/edit_profile.dart';
import 'package:swd392/Profile/profile.dart';
import 'package:swd392/Search/search_ticket.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({Key? key}) : super(key: key);

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Prevent default back navigation
        }
        return true; // Allow default back navigation
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
            ),
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
                icon: Icon(Icons.home, size: 30),
                selectedIcon: Icon(Icons.home, color: Colors.white),
                label: "Trang chủ",
              ),
              NavigationDestination(
                icon: Icon(Icons.qr_code, size: 30),
                selectedIcon: Icon(Icons.qr_code, color: Colors.white),
                label: "Tra cứu",
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications, size: 30),
                selectedIcon: Icon(Icons.notifications, color: Colors.white),
                label: "Thông báo",
              ),
              NavigationDestination(
                icon: Icon(Icons.person, size: 30),
                selectedIcon: Icon(Icons.person, color: Colors.white),
                label: "Tài khoản",
              ),
            ],
          ),
        ),
        body: Center(
          child: _getSelectedPage(_selectedIndex),
        ),
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
        return NotificationPage();
      case 3:
        return ProfilePage();
      default:
        return MyHomePage();
    }
  }
}
