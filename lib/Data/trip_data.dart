
import 'package:swd392/Data/trip.dart';

DateTime now = DateTime.now();
DateTime today = DateTime(now.year, now.month, now.day);

List<Trip> trips = [
      Trip(
        startLocation: 'TP Hồ Chí Minh',
        endLocation: 'Bến Tre',
        time: DateTime(now.year, now.month, now.day, 9),
        date: DateTime(now.year, now.month, now.day),
      ),
      Trip(
        startLocation: 'Hà Nội',
        endLocation: 'Hà Giang',
        time: DateTime(now.year, now.month, now.day, 12),
        date: DateTime(now.year, now.month, now.day),
      ),
      Trip(
        startLocation: 'TP Hồ Chí Minh',
        endLocation: 'Vũng Tàu',
        time: DateTime(now.year, now.month, now.day, 15),
        date: DateTime(now.year, now.month, now.day),
      ),
      Trip(
        startLocation: 'Bình Thuận',
        endLocation: 'Bến Tre',
        time: DateTime(now.year, now.month, now.day, 18),
        date: DateTime(now.year, now.month, now.day),
      ),
      Trip(
        startLocation: 'Hà Nội',
        endLocation: 'Bến Tre',
        time: DateTime(now.year, now.month, now.day + 1, 9),
        date: DateTime(now.year, now.month, now.day + 1),
      ),
      Trip(
        startLocation: 'TP Hồ Chí Minh',
        endLocation: 'Vũng Tàu',
        time: DateTime(now.year, now.month, now.day + 1, 12),
        date: DateTime(now.year, now.month, now.day + 1),
      ),
      Trip(
        startLocation: 'TP Hồ Chí Minh',
        endLocation: 'Vũng Tàu',
        time: DateTime(now.year, now.month, now.day + 1, 15),
        date: DateTime(now.year, now.month, now.day + 1),
      ),
      Trip(
        startLocation: 'Bình Thuận',
        endLocation: 'Ninh Thuận',
        time: DateTime(now.year, now.month, now.day + 1, 18),
        date: DateTime(now.year, now.month, now.day + 1),
      ),
    ];