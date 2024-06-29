import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_detail.dart';
import 'package:swd392/models/notification_model.dart';
import 'package:swd392/Data/notification_data.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  void _navigateToNotificationDetail(BuildContext context, NotificationModel notification) async {
    // Mark notification as read locally
    setState(() {
      notification.read = true;
    });

    // Navigate to NotificationDetailPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotificationDetailPage(notification: notification)),
    );

    // Handle result from NotificationDetailPage if needed
    if (result != null && result is NotificationModel) {
      setState(() {
        // Update notification list based on the result
        notifications = notifications.map((notif) {
          return notif.id == result.id ? result : notif;
        }).toList();
      });
    }
  }

  void _markAllRead() {
    setState(() {
      notifications.forEach((notif) {
        notif.read = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: Icon(Icons.mark_chat_read_sharp),
            onPressed: () {
              _markAllRead();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return GestureDetector(
              onTap: () {
                _navigateToNotificationDetail(context, notification);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: notification.read ? Colors.white : Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: notification.read ? Colors.grey : Colors.blue,
                      width: 1,
                    )),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
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
                  trailing: notification.read ? null : Icon(Icons.circle, color: Colors.blue),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
