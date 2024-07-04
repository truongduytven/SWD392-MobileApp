import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd392/Trip/list_ticket.dart';
import 'package:swd392/Trip/trip_detail.dart';
import 'package:swd392/models/trip_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class ListTripPage extends StatefulWidget {
  const ListTripPage({super.key});

  @override
  State<ListTripPage> createState() => _ListTripPageState();
}

class _ListTripPageState extends State<ListTripPage> {
  List<Trip> trips = [];
  DateTime today = DateTime.parse('2024-08-20');
  String token = '';
  String userID = '';
  String filter = 'All';
  String startLocationFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      setState(() {
        userID = prefs.getString('userID') ?? '';
        token = prefs.getString('token') ?? '';
      });
    }
    fetchTripsData();
  }

  Future<void> fetchTripsData() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    final String dateString = '2024-08-20';
    try {
      final response = await http.get(
        Uri.parse(
            'https://ticket-booking-swd392-project.azurewebsites.net/trip-management/managed-trips/staff/${userID}/start-time/${dateString}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          trips =
              jsonResponse.map((tripJson) => Trip.fromJson(tripJson)).toList();
        });
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "Cập nhật chuyến đi thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Navigator.of(context).pop();
        throw Exception('Failed to load trips');
      }
    } catch (error) {
      Navigator.of(context).pop();
      print('Error fetching trips: $error');
    }
  }

  List<Trip> getFilteredTrips() {
    List<Trip> filteredTrips =
        trips.where((trip) => trip.startDate.isAtSameMomentAs(today)).toList();

    if (filter == 'Checked') {
      filteredTrips = filteredTrips.where((trip) => trip.isChecked).toList();
    } else if (filter == 'Unchecked') {
      filteredTrips = filteredTrips.where((trip) => !trip.isChecked).toList();
    }

    if (startLocationFilter != 'All') {
      filteredTrips = filteredTrips
          .where((trip) => trip.startLocation == startLocationFilter)
          .toList();
    }

    return filteredTrips;
  }

  @override
  Widget build(BuildContext context) {
    List<String> startLocations = ['All'];
    startLocations
        .addAll(trips.map((trip) => trip.startLocation).toSet().toList());

    List<Trip> filteredTrips = getFilteredTrips();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Soát vé - ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(today),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.orange[50],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: filter,
                        onChanged: (String? newValue) {
                          setState(() {
                            filter = newValue!;
                          });
                        },
                        items: const <String>['All', 'Checked', 'Unchecked']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == 'All'
                                  ? 'Tất cả'
                                  : value == 'Checked'
                                      ? 'Đã soát vé'
                                      : 'Chưa soát vé',
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Điểm xuất phát:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.orange[50],
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.orange, width: 0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: startLocationFilter,
                        onChanged: (String? newValue) {
                          setState(() {
                            startLocationFilter = newValue!;
                          });
                        },
                        items: startLocations
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == 'All' ? 'Tất cả' : value,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: filteredTrips.isEmpty
                ? Center(
                    child: Text(
                      'Không có chuyến nào trong ngày',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTrips.length,
                    itemBuilder: (context, index) {
                      final trip = filteredTrips[index];
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('HH:mm')
                                                .format(trip.startTime),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            DateFormat('HH:mm')
                                                .format(trip.endTime),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.pin_drop_outlined,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                trip.startLocation,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.pin_drop,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                trip.endLocation,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        trip.isChecked
                                            ? 'Quá hạn'
                                            : 'Chưa soát',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: trip.isChecked
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            //Button chi tiết và soát vé
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TripDetailPage(trip: trip);
                                    }));
                                  },
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: const Text(
                                        'Chi tiết',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!trip.isChecked)
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ListTicketPage(
                                          tripID: trip.tripID,
                                        );
                                      }));
                                    },
                                    child: Container(
                                      height: 40,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.orange,
                                      ),
                                      child: Center(
                                        child: const Text(
                                          'Soát vé',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
