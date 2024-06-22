import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notification_detail.dart';
import 'notification_model.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      title: "Thông báo đặt vé xe online",
      content: "Bạn đã đặt vé xe thành công qua hệ thống online của chúng tôi.",
      read: false,
      receivedTime: DateTime.now().subtract(Duration(hours: 1)), // Example time
    ),
    NotificationModel(
      id: 2,
      title: "Cập nhật thông tin đặt vé xe",
      content: "Thông tin chi tiết về đơn đặt vé của bạn đã được cập nhật.",
      read: true,
      receivedTime: DateTime.now().subtract(Duration(days: 1)), // Example time
    ),
    NotificationModel(
      id: 3,
      title: "Hướng dẫn đặt vé xe trực tuyến",
      content: "Xem hướng dẫn chi tiết để đặt vé xe trực tuyến dễ dàng hơn.",
      read: false,
      receivedTime:
          DateTime.now().subtract(Duration(minutes: 30)), // Example time
    ),
    NotificationModel(
      id: 4,
      title: "Nhắc nhở thanh toán vé xe",
      content:
          "Vui lòng thanh toán đơn đặt vé trước thời hạn để đảm bảo chỗ ngồi.",
      read: false,
      receivedTime: DateTime.now().subtract(Duration(hours: 2)), // Example time
    ),
    NotificationModel(
      id: 5,
      title: "Thông tin lộ trình chuyến đi",
      content:
          "Thông tin chi tiết về lộ trình và thời gian chuyến đi của bạn đã sẵn sàng.",
      read: true,
      receivedTime: DateTime.now().subtract(Duration(days: 2)), // Example time
    ),
    NotificationModel(
      id: 6,
      title: "Chương trình khuyến mãi vé xe online",
      content:
          "Khám phá các chương trình khuyến mãi đặc biệt khi đặt vé xe qua hệ thống online.",
      read: false,
      receivedTime: DateTime.now().subtract(Duration(hours: 3)), // Example time
    ),
  ];

  void _navigateToNotificationDetail(
      BuildContext context, NotificationModel notification) async {
    // Mark notification as read locally
    setState(() {
      notification.read = true;
    });

    // Navigate to NotificationDetailPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NotificationDetailPage(notification: notification)),
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
                  // subtitle: Text(notification.content),
                  trailing: notification.read
                      ? null
                      : Icon(Icons.circle, color: Colors.blue),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    // Format timestamp to desired format, e.g., "HH:mm dd/MM/yyyy"
    return "${timestamp.hour}:${timestamp.minute} ${timestamp.day}/${timestamp.month}/${timestamp.year}";
  }
}
