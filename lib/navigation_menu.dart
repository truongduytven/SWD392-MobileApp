import 'package:flutter/material.dart';
import 'package:swd392/Home/homepage.dart';
import 'package:swd392/Login/login.dart';
import 'package:swd392/Profile/profile.dart';
import 'package:swd392/Search/search_ticket.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Ensure you import the LoginPage

class NavigationMenu extends StatefulWidget {

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0; // Currently selected index, starts with Home

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false; // Prevent default back navigation
        } else {
          await _showLogoutDialog(); // Show logout dialog
          return false; // Prevent default back navigation
        }
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
              // NavigationDestination(
              //   icon: Icon(Icons.notifications, size: 30),
              //   selectedIcon: Icon(Icons.notifications, color: Colors.white),
              //   label: "Thông báo",
              // ),
              NavigationDestination(
                icon: Icon(Icons.person, size: 30),
                selectedIcon: Icon(Icons.person, color: Colors.white),
                label: "Tài khoản",
              ),
            ],
          ),
        ),
        body: Center(
          child: _getSelectedPage(_selectedIndex), // Display selected page
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update selected index
    });
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return MyHomePage(); // Home Page
      case 1:
        return SearchTicketPage(); // Search Ticket Page
      // case 2:
      //   return NotificationPage(); // Notification Page
      case 2:
        return ProfilePage(); // Profile Page
      default:
        return MyHomePage(); // Default to Home Page
    }
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc muốn đăng xuất?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: Text('Đăng xuất'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear(); // Clear all stored data

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                ); // Navigate to login page and remove all previous routes
              },
            ),
          ],
        );
      },
    );
  }
}
