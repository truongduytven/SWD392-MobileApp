class TicketDetail {
  final String qrCodeImage;
  final String status;
  final String name;
  final String phoneNumber;
  final String startTime;
  final String startDay;
  final String seatCode;
  final String route;
  final List<Service> services;

  TicketDetail({
    required this.qrCodeImage,
    required this.status,
    required this.name,
    required this.phoneNumber,
    required this.startTime,
    required this.startDay,
    required this.seatCode,
    required this.route,
    required this.services,
  });

  factory TicketDetail.fromJson(Map<String, dynamic> json) {
    var list = json['Services'] as List;
    List<Service> serviceList = list.map((i) => Service.fromJson(i)).toList();

    return TicketDetail(
      qrCodeImage: json['QrCodeImage'],
      status: json['Status'],
      name: json['Name'],
      phoneNumber: json['PhoneNumber'],
      startTime: json['StartTime'],
      startDay: json['StartDay'],
      seatCode: json['SeatCode'],
      route: json['Route'],
      services: serviceList,
    );
  }
}

class Service {
  final String serviceName;
  final int quantity;
  final String station;
  final int totalPrice;

  Service({
    required this.serviceName,
    required this.quantity,
    required this.station,
    required this.totalPrice,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      serviceName: json['ServiceName'],
      quantity: json['Quantity'],
      station: json['Station'],
      totalPrice: json['TotalPrice'],
    );
  }
}
