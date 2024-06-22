import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_model.dart'; // Assuming you have a NotificationModel

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailPage({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mark notification as read immediately upon opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!notification.read) {
        notification.read = true;
        Navigator.pop(context, notification); // Pass updated notification back
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Thông báo",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade600
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  notification.receivedTime != null
                      ? "${DateFormat('HH:mm dd/MM/yyyy').format(notification.receivedTime!)}"
                      : "Unknown time",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  notification.content,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center, 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
