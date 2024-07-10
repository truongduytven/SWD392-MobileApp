import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd392/Trip/scan_ticket.dart';

class ListTicketPage extends StatefulWidget {
  final String tripID;

  const ListTicketPage({super.key, required this.tripID});

  @override
  _ListTicketPageState createState() => _ListTicketPageState();
}

class _ListTicketPageState extends State<ListTicketPage> {
  String filter = 'All';
  List<Ticket> tickets = [];
  bool isLoading = true;
  String token = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleReturnedFromResultSearch();
    });
  }

  void fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    if (token.isNotEmpty) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
    }
    fetchTickets();
  }

  void _handleReturnedFromResultSearch() {
  // Retrieve the arguments from the previous route if not null
  final args = ModalRoute.of(context)?.settings.arguments;

  // Check if arguments is not null and of type bool
  if (args != null && args is bool && args) {
    fetchTickets();
  }
}

  Future<void> fetchTickets() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://ticket-booking-swd392-project.azurewebsites.net/trip-management/manage-trips/${widget.tripID}/seats'),
        headers: {
          'Authorization': 'Bearer $token', // Replace with your token
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body)['Result'];
        setState(() {
          tickets = jsonResponse.map((ticketJson) {
            return Ticket(
              ticketID: ticketJson[0],
              title: ticketJson[1],
              isChecked: ticketJson[2] == 'ĐÃ SỬ DỤNG',
            );
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (error) {
      print('Error fetching tickets: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Ticket> filteredTickets;
    if (filter == 'Checked') {
      filteredTickets = tickets.where((ticket) => ticket.isChecked).toList();
    } else if (filter == 'Unchecked') {
      filteredTickets = tickets.where((ticket) => !ticket.isChecked).toList();
    } else {
      filteredTickets = tickets;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Soát vé",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.orange[50],
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange,
                              width: 0.5), // Smaller width and orange color
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      value: filter,
                      onChanged: (String? newValue) {
                        setState(() {
                          filter = newValue!;
                        });
                      },
                      items: <String>['All', 'Checked', 'Unchecked']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value == 'All'
                                ? 'Tất cả'
                                : value == 'Checked'
                                    ? 'Đã soát vé'
                                    : 'Chưa soát vé',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredTickets.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                        onPressed: () {
                          filteredTickets[index].isChecked ? {} : 
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ScanTicketPage(
                              tripID: widget.tripID,
                            );
                          })).then((value) {
                            fetchTickets();
                          });
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(
                              'Số ghế: ' + filteredTickets[index].title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(
                              filteredTickets[index].isChecked
                                  ? Icons.check
                                  : Icons.close,
                              color: filteredTickets[index].isChecked
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
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

class Ticket {
  final String title;
  final bool isChecked;
  final String ticketID;

  Ticket(
      {required this.ticketID, required this.title, required this.isChecked});
}
