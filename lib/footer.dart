import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyFooter extends StatelessWidget {
  const MyFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: GNav(
        color: Colors.orange,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.orange,
        gap: 8,
        padding: EdgeInsets.all(20),
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Trang chủ',
          ),
          GButton(
            icon: Icons.qr_code,
            text: 'Tra cứu vé',
          ),
          GButton(
            icon: Icons.notifications,
            text: 'Thông báo',
          ),
          GButton(
            icon: Icons.person,
            text: 'Thông tin',
          ),
        ],
      ),
    );
  }
}