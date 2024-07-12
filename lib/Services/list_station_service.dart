import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, bool> selectedServices = {};

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
    // Fetch local data based on selected station
    fetchLocalData(station);
  }

  Future<void> fetchLocalData(String? stationID) async {
    if (stationID == null) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? saveServicesDataString = prefs.getString('SaveServicesData');

    if (saveServicesDataString != null) {
      Map<String, dynamic> saveServicesData =
          json.decode(saveServicesDataString);

      if (saveServicesData.containsKey(widget.tripID)) {
        List<dynamic> tickets = saveServicesData[widget.tripID]['Tickets'];
        setState(() {
          filteredTickets = tickets.where((ticket) {
            return ticket['Services'].any((service) =>
                service['StationID'] == stationID && !service['HasCheck']);
          }).toList();
        });
        if (filteredTickets.isEmpty) {
          Fluttertoast.showToast(
            msg: "Không tìm thấy dịch vụ nào cho trạm đã chọn!",
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

  void onCheckboxChanged(bool? value, String ticketDetailServiceID) {
    setState(() {
      selectedServices[ticketDetailServiceID] = value ?? false;
    });
  }

  Future<void> updateServiceStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? saveServicesDataString = prefs.getString('SaveServicesData');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );
    if (saveServicesDataString != null) {
      Map<String, dynamic> saveServicesData =
          json.decode(saveServicesDataString);

      List<String> postData = [];

      for (var ticket in filteredTickets) {
        for (var service in ticket['Services']) {
          if (selectedServices[service['TicketDetailServiceID']] == true) {
            postData.add(service['TicketDetailServiceID']);
          }
        }
      }

      try {
        final response = await http.put(
          Uri.parse(
              'https://ticket-booking-swd392-project.azurewebsites.net/ticket-detail-management/managed-ticket-details/service-trackers'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(postData),
        );

        if (response.statusCode == 200) {

          // Update local data and SharedPreferences after successful API call
          for (var ticket in saveServicesData[widget.tripID]['Tickets']) {
            ticket['Services'].forEach((service) {
              if (selectedServices[service['TicketDetailServiceID']] == true) {
                service['HasCheck'] = true;
              }
            });
          }

          prefs.setString('SaveServicesData', json.encode(saveServicesData));

          // Refresh the local data
          fetchLocalData(selectedStation);

          // Clear selected services after update
          setState(() {
            selectedServices.clear();
          });
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Cập nhật trạng thái dịch vụ thành công!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Lỗi khi cập nhật trạng thái",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (error) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: "Có lỗi xảy ra khi cập nhật trạng thái dịch vụ!",
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

  void showConfirmationDialog(int selectedCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận"),
          content: Text(
              "Bạn có chắc chắn muốn xác nhận đã sử dụng $selectedCount dịch vụ không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Hủy", style: TextStyle(color: Colors.orange)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.of(context).pop();
                updateServiceStatus();
              },
              child: Text("Xác nhận", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount =
        selectedServices.values.where((isChecked) => isChecked).length;

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
            hint: Text('Chọn trạm', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            dropdownColor: Colors.white,
            value: selectedStation,
            alignment: Alignment.center,
            onChanged: onSelectStation,
            items: stations.map((station) {
              return DropdownMenuItem<String>(
                value: station.stationID,
                child: Text(station.name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: selectedStation == null
                ? Center(child: Text('Vui lòng chọn trạm trước'))
                : ListView.builder(
                    itemCount: filteredTickets.length,
                    itemBuilder: (context, index) {
                      var ticket = filteredTickets[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: ticket['Services'].map<Widget>((service) {
                          if (service['StationID'] != selectedStation || service['HasCheck'])
                            return Container();
                          return Card(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Image.network(
                                    service['ImageUrl'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Khách hàng: ${ticket['Name']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Text('Mã ghế: ${ticket['SeatCode']}'),
                                        Text(
                                            'Tên dịch vụ: ${service['ServiceName']}'),
                                        Text(
                                            'Số lượng: ${service['Quantity']}'),
                                      ],
                                    ),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.orange,
                                    value: selectedServices[
                                            service['TicketDetailServiceID']] ??
                                        false,
                                    onChanged: (value) => onCheckboxChanged(
                                        value,
                                        service['TicketDetailServiceID']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
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
                  child: ElevatedButton(
                    onPressed: selectedCount > 0
                        ? () => showConfirmationDialog(selectedCount)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Xác nhận $selectedCount dịch vụ",
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
