import 'package:flutter/material.dart';
import 'package:swd392/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAHLbI6ZX2rGcO1OuZwC9kQ5EHc44Un-QA',
      appId: '1:961942166833:android:5dd0f298f2f7e0c0c2e410',
      messagingSenderId: '961942166833',
      projectId: 'swd392-4a610',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
