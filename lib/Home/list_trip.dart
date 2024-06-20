import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swd392/Home/list_ticket.dart';

class ListTripPage extends StatefulWidget {
  const ListTripPage({super.key});

  @override
  State<ListTripPage> createState() => _ListTripPageState();
}

class _ListTripPageState extends State<ListTripPage> {
  String filter = 'All';
  String startLocationFilter = 'All';

  @override
  Widget build(BuildContext context) {
    // Update trip status based on current time
    // Get the current date
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Define specific trip times for today
    List<Trip> trips = [
      Trip(
          startLocation: 'TP Hồ Chí Minh',
          endLocation: 'Bến Tre',
          time: today.add(Duration(hours: 9))),
      Trip(
          startLocation: 'Hà Nội',
          endLocation: 'Hà Giang',
          time: today.add(Duration(hours: 12))),
      Trip(
          startLocation: 'TP Hồ Chí Minh',
          endLocation: 'Vũng Tàu',
          time: today.add(Duration(hours: 15))),
      Trip(
          startLocation: 'Bình Thuận',
          endLocation: 'Bến Tre',
          time: today.add(Duration(hours: 18))),
      Trip(
          startLocation: 'Hà Nội',
          endLocation: 'Bến Tre',
          time: today.add(Duration(hours: 9))),
      Trip(
          startLocation: 'TP Hồ Chí Minh',
          endLocation: 'Vũng Tàu',
          time: today.add(Duration(hours: 12))),
      Trip(
          startLocation: 'TP Hồ Chí Minh',
          endLocation: 'Vũng Tàu',
          time: today.add(Duration(hours: 15))),
      Trip(
          startLocation: 'Bình Thuận',
          endLocation: 'Ninh Thuận',
          time: today.add(Duration(hours: 18))),
    ];

    trips.sort((a, b) => a.time.compareTo(b.time));

    for (var trip in trips) {
      if (trip.time.isBefore(now)) {
        trip.isChecked = true;
      }
    }

    // Get unique start locations
    List<String> startLocations = ['All'];
    startLocations
        .addAll(trips.map((trip) => trip.startLocation).toSet().toList());

    // Filter trips based on selection
    List<Trip> filteredTrips = trips;
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Soát vé",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Column(
        children: [
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
            child: ListView.builder(
              itemCount: filteredTrips.length,
              itemBuilder: (context, index) {
                final trip = filteredTrips[index];
                final endTime = trip.time.add(Duration(hours: 3));
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
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
                                      DateFormat('HH:mm').format(trip.time),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      DateFormat('HH:mm').format(endTime),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            fontSize: 20,
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
                                            fontSize: 20,
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
                                      ? 'Đã soát vé'
                                      : 'Chưa soát vé',
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
                              // Add your detail action here
                            },
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 3,
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
                                  return ListTicketPage();
                                }));
                              },
                              child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 3,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
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

class Trip {
  final String startLocation;
  final String endLocation;
  final DateTime time;
  bool isChecked;

  Trip(
      {required this.endLocation,
      required this.startLocation,
      required this.time,
      this.isChecked = false});
}
