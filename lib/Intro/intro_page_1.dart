import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Add the lottie package for animations

class IntroPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Lottie.network(
                "https://lottie.host/100c431b-68a5-4ab2-96a2-f3b75e37e56a/ghqF8sx8fF.json",
                height: 300),
            Text(
              'Why choose The Bus Journey?',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Text(
                'Discover the simplest way to book your bus tickets online. Choose your route, select your seat, and travel hassle-free!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
