import 'package:swd392/models/notification_model.dart';

List<NotificationModel> notifications = [
  NotificationModel(
    id: 1,
    title: "Thông báo đặt vé xe online",
    content: "Bạn đã đặt vé xe thành công qua hệ thống online của chúng tôi.",
    read: false,
    receivedTime: DateTime.now().subtract(Duration(hours: 1)),
  ),
  NotificationModel(
    id: 2,
    title: "Cập nhật thông tin đặt vé xe",
    content: "Thông tin chi tiết về đơn đặt vé của bạn đã được cập nhật.",
    read: true,
    receivedTime: DateTime.now().subtract(Duration(days: 1)),
  ),
  NotificationModel(
    id: 3,
    title: "Hướng dẫn đặt vé xe trực tuyến",
    content: "Xem hướng dẫn chi tiết để đặt vé xe trực tuyến dễ dàng hơn.",
    read: false,
    receivedTime: DateTime.now().subtract(Duration(minutes: 30)),
  ),
  NotificationModel(
    id: 4,
    title: "Nhắc nhở thanh toán vé xe",
    content: "Vui lòng thanh toán đơn đặt vé trước thời hạn để đảm bảo chỗ ngồi.",
    read: false,
    receivedTime: DateTime.now().subtract(Duration(hours: 2)),
  ),
  NotificationModel(
    id: 5,
    title: "Thông tin lộ trình chuyến đi",
    content: "Thông tin chi tiết về lộ trình và thời gian chuyến đi của bạn đã sẵn sàng.",
    read: true,
    receivedTime: DateTime.now().subtract(Duration(days: 2)),
  ),
  NotificationModel(
    id: 6,
    title: "Chương trình khuyến mãi vé xe online",
    content: "Khám phá các chương trình khuyến mãi đặc biệt khi đặt vé xe qua hệ thống online.",
    read: false,
    receivedTime: DateTime.now().subtract(Duration(hours: 3)),
  ),
];
