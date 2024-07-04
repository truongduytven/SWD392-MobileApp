import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swd392/Trip/list_trip.dart';
import 'package:swd392/Trip/list_trip_all_day.dart';
import 'package:swd392/Notification/notification.dart';
import 'package:swd392/models/notification_model.dart';
import 'package:swd392/Data/notification_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    // Fetch user information from SharedPreferences
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {
    List<NotificationModel> unreadNotifications =
        notifications.where((notif) => !notif.read).toList();

    // Determine number of notifications to display (maximum 5)
    final int maxNotificationsToShow = 5;
    int notificationsCount = unreadNotifications.length > maxNotificationsToShow
        ? maxNotificationsToShow
        : unreadNotifications.length;
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
                                userName,
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
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          wordSpacing: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          // SizedBox(width: 30),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.directions_bus, size: 28),
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ListTripAllDayPage();
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
                          // SizedBox(width: 30),
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
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Thông báo mới",
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
                                  // Navigate to view all notifications
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotificationPage()));
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
                            itemCount: notificationsCount,
                            itemBuilder: (context, index) {
                              final notification = unreadNotifications[index];
                              return Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(
                                    vertical: 5),
                                decoration: BoxDecoration(
                                    color: notification.read
                                        ? Colors.white
                                        : Colors.blue[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: notification.read
                                          ? Colors.grey
                                          : Colors.blue,
                                      width: 1,
                                    )),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.title,
                                        style: TextStyle(
                                          fontWeight: notification.read
                                              ? FontWeight.normal
                                              : FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        notification.receivedTime != null
                                            ? "${DateFormat('HH:mm dd/MM/yyyy').format(notification.receivedTime!)}"
                                            : "Unknown time",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // trailing: notification.read
                                  //     ? null
                                  //     : Icon(Icons.circle, color: Colors.blue, size: 15,),
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
