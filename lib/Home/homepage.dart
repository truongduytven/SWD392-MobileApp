import 'package:flutter/material.dart';
import 'package:swd392/Home/list_trip.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  colors: [
                    Colors.orange.shade900,
                    Colors.orange.shade600,
                    Colors.orange.shade400,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[
                        Center(
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.jpg'),
                            radius: 35,
                          ),
                        ),
                        SizedBox(width: 10),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Xin chào,",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                              Text(
                                "Nguyễn Thị Mộng Tiên",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
            Transform.translate(
              offset: Offset(0, -60),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 2),
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: Text(
                                  "12",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Chuyến đã hoàn thành",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "20",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                              Text(
                                "Chuyến đi hôm nay",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Chức năng chính",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.qr_code_scanner, size: 28),
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                    return ListTripPage();
                                  }));
                                },
                              ),
                              Text(
                                "Soát vé",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.directions_bus, size: 28),
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                    return ListTripPage();
                                  }));
                                },
                              ),
                              Text(
                                "Chuyến đi",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 30),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.schedule, size: 28),
                                onPressed: () {
                                  // Navigate to Lịch trình
                                },
                              ),
                              Text(
                                "Lịch trình",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Thông báo",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                  wordSpacing: 2,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigate to Thông báo
                                },
                                child: Text(
                                  "Xem tất cả",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.orange,
                                    decorationThickness: 2,
                                    fontSize: 15,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5, // Replace with your actual list size
                            itemBuilder: (context, index) {
                              // Replace with your notification item widget
                              return Container(
                                width: double.infinity,
                                height: 100,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/bus.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "Tuyến Sài Gòn- Hà Nội: thay đổi lịch trình",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
