import 'package:flutter/material.dart';
import 'package:swd392/get_start.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: GetStartedPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
