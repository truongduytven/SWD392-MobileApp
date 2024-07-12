class Trip {
  final String tripID;
  final String routeID;
  final String templateID;
  final String companyName;
  final String companyID;
  final String imageUrl;
  final double averageRating;
  final int quantityRating;
  final String startLocation;
  final String endLocation;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startTime;
  final DateTime endTime;
  final int emptySeat;
  final int price;
  final bool isChecked;

  Trip({
    required this.tripID,
    required this.routeID,
    required this.templateID,
    required this.companyName,
    required this.companyID,
    required this.imageUrl,
    required this.averageRating,
    required this.quantityRating,
    required this.startLocation,
    required this.endLocation,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.emptySeat,
    required this.price,
    required this.isChecked,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    DateTime startDate = DateTime.parse(json['StartDate']);
    DateTime endDate = DateTime.parse(json['EndDate']);
    
    DateTime startTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      int.parse(json['StartTime'].split(":")[0]),
      int.parse(json['StartTime'].split(":")[1]),
    );
    
    DateTime endTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      int.parse(json['EndTime'].split(":")[0]),
      int.parse(json['EndTime'].split(":")[1]),
    );

    bool isChecked = DateTime.now().isAfter(startTime);

    return Trip(
      tripID: json['TripID'],
      routeID: json['RouteID'],
      templateID: json['TemplateID'],
      companyName: json['CompanyName'],
      companyID: json['CompanyID'],
      imageUrl: json['ImageUrl'],
      averageRating: json['AverageRating'].toDouble(),
      quantityRating: json['QuantityRating'],
      startLocation: json['StartLocation'],
      endLocation: json['EndLocation'],
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      emptySeat: json['EmptySeat'],
      price: json['Price'],
      isChecked: isChecked,
    );
  }
}
