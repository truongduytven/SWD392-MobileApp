class Trip {
  final String startLocation;
  final String endLocation;
  final DateTime time;
  final DateTime date;
  bool isChecked;

  Trip(
      {required this.endLocation,
      required this.startLocation,
      required this.date,
      required this.time,
      this.isChecked = false});
}