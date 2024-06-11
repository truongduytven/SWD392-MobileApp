import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:TheBusJourney/Home/homepage.dart';
import 'package:TheBusJourney/Intro/Intro_page_1.dart';
import 'package:TheBusJourney/Intro/Intro_page_2.dart';
import 'package:TheBusJourney/Intro/Intro_page_3.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        //page view
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),
        //dot indicators
        Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyHomePage();
                      }));
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                      ),
                    )),
                //dot indicators
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    activeDotColor: Colors.orange,
                    dotColor: Colors.orange.withOpacity(0.5),
                  ),
                ),
                //next or done
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MyHomePage();
                          }));
                        },
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                          ),
                        ))
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 18,
                          ),
                        ))
              ],
            )),
      ],
    ));
  }
}
