import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:swd392/Login/login.dart';
// import 'package:swd392/navigation_menu.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Material(
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(40),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.6,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.only(
                            bottomRight: Radius.circular(70),
                          )),
                  // child: Center(
                    // child: ClipRRect(
                    //   borderRadius: BorderRadius.circular(20),
                    //   child: Container(
                    //     padding: EdgeInsets.all(20),
                    //     decoration: BoxDecoration(
                    //       // color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     child: Lottie.network(
                    //       "https://lottie.host/2110e1bd-10b0-4ab5-a0de-a138acf6e65e/40YSCww07S.json",
                    //       height: 300,
                    //       // fit: BoxFit.fill,  
                    //     ),
                    //   ),
                    // ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                          bottomRight: Radius.circular(70),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Lottie.asset("assets/BusAnimation.json", height: 300),
                    ), 
                  ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.666,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.666,
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(70))),
                    child: Column(
                      children: [
                        Text(
                          "Chào mừng đến với",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            wordSpacing: 2,
                          ),
                        ),
                        Text(
                          "The Bus Journey",
                          style: TextStyle(
                            color: Colors.orange.shade400,
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            wordSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            "Ứng dụng giúp bạn dễ dàng tìm kiếm thông tin vé, mua vé, mua dịch vụ đi kèm và theo dõi lịch trình của mình.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Material(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 80),
                              child: Text(
                                "Bắt đầu ngay",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
