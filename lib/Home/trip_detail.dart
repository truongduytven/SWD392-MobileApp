import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/trip_model.dart';

class TripDetailPage extends StatefulWidget {
  final Trip trip;

  const TripDetailPage({super.key, required this.trip});

  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Chi tiết chuyến đi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Chuyến:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${widget.trip.startLocation} - ${widget.trip.endLocation}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add space between rows
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Thời gian:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${DateFormat('HH:mm').format(widget.trip.time)} - ${DateFormat('HH:mm').format(widget.trip.time.add(Duration(hours: 3)))} ${DateFormat('dd/MM/yyyy').format(widget.trip.time)} ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add space between rows
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tổng số ghế:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '20', // Placeholder, replace with actual data if available
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add space between rows
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Giá vé:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '200.000 - 250.000 VND', // Placeholder, replace with actual data if available
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add space between rows
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tình trạng soát vé:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.trip.isChecked ? 'Quá hạn' : 'Chưa soát',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add space between rows
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Số điện thoại:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '0123456789', // Placeholder, replace with actual data if available
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Add space between rows
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ghi chú:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Không có', // Placeholder, replace with actual data if available
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}