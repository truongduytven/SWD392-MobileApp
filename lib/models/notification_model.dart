class NotificationModel {
  final int id;
  final String title;
  final String content;
  bool read;
  final DateTime? receivedTime; // New property for timestamp

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.read,
    required this.receivedTime,
  });
}
