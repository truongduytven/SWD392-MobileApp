class Station {
  final String name;
  final String stationID;

  Station({required this.name, required this.stationID});

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      name: json['Name'],
      stationID: json['StationID'],
    );
  }
}