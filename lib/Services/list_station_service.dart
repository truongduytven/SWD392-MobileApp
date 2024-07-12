import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Assuming these are defined elsewhere in your codebase
import 'package:swd392/Services/scan_service.dart';
import 'package:swd392/models/service.dart';

class SelectStationPage extends StatefulWidget {
  final String tripID;
  final String routeID;
  final String companyID;

  const SelectStationPage({
    Key? key,
    required this.tripID,
    required this.routeID,
    required this.companyID,
  }) : super(key: key);

  @override
  _SelectStationPageState createState() => _SelectStationPageState();
}

class _SelectStationPageState extends State<SelectStationPage> {
  List<Station> stations = [];
  String? selectedStation;
  String token = '';
  List<dynamic> filteredTickets = [];

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
        token = prefs.getString('token') ?? '';
      });
    }
    fetchStations();
  }

  Future<void> fetchStations() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      final response = await http.get(
        Uri.parse(
            'https://ticket-booking-swd392-project.azurewebsites.net/station-management/managed-stations/routes/${widget.routeID}/companyID/${widget.companyID}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          stations =
              jsonResponse.map((station) => Station.fromJson(station)).toList();
        });
        Navigator.of(context).pop();
        Fluttertoast.showToast(
          msg: "Cập nhật các trạm thành công!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Navigator.of(context).pop();
        throw Exception('Failed to load stations');
      }
    } catch (error) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra khi cập nhật trạm!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void onSelectStation(String? station) {
    setState(() {
      selectedStation = station;
    });
    print(station);
    // Fetch local data based on selected station
    fetchLocalData(station);
  }

  Future<void> fetchLocalData(String? stationID) async {
    if (stationID == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? saveServicesDataString = prefs.getString('SaveServicesData');

    if (saveServicesDataString != null) {
      Map<String, dynamic> saveServicesData = json.decode(saveServicesDataString);

      if (saveServicesData.containsKey(widget.tripID)) {
        List<dynamic> tickets = saveServicesData[widget.tripID]['Tickets'];
        setState(() {
          filteredTickets = tickets.where((ticket) {
            return ticket['Services'].any((service) => service['StationID'] == stationID);
          }).toList();
        });
        print(saveServicesData);
        if (filteredTickets.isEmpty) {
          Fluttertoast.showToast(
            msg: "Không tìm thấy vé nào cho trạm đã chọn!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Soát dịch vụ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          DropdownButton<String>(
            hint: Text('Chọn trạm'),
            value: selectedStation,
            onChanged: onSelectStation,
            items: stations.map((station) {
              return DropdownMenuItem<String>(
                value: station.stationID,
                child: Text(station.name),
              );
            }).toList(),
          ),
          Expanded(
            child: selectedStation == null
                ? Center(child: Text('Vui lòng chọn trạm trước'))
                : ListView.builder(
                    itemCount: filteredTickets.length,
                    itemBuilder: (context, index) {
                      var ticket = filteredTickets[index];
                      return ListTile(
                        title: Text(ticket['Name']),
                        subtitle: Text('Seat: ${ticket['SeatCode']}'),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      );
                    },
                  ),
          ),
          if (selectedStation != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to QR Scan Page
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Quét mã QR",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Station {
  final String stationID;
  final String name;

  Station({
    required this.stationID,
    required this.name,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      stationID: json['StationID'],
      name: json['Name'],
    );
  }
}
