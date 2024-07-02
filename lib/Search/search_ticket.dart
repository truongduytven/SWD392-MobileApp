import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd392/Data/ticket_detail.dart';
import 'package:swd392/Search/result_Search.dart';

class SearchTicketPage extends StatefulWidget {
  const SearchTicketPage({super.key});

  @override
  State<SearchTicketPage> createState() => _SearchTicketPageState();
}

class _SearchTicketPageState extends State<SearchTicketPage> {
  bool isComplete = false;
  String token = '';
  void closeScreen() {
    isComplete = false;
  }

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
  }

  Future<void> fetchTicketDetails(String code) async {
    // Show loading modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );
    print("code la " + code);
    try {
      // Replace with your API endpoint
      Response response = await get(
        Uri.parse('https://ticket-booking-swd392-project.azurewebsites.net/ticket-detail-management/managed-ticket-details/qrCodes/$code'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response
        final ticketDetail = TicketDetail.fromJson(json.decode(response.body));

        // Close the loading modal
        Navigator.of(context).pop();

        // Navigate to the result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultSearch(
              code: code,
              closeScreen: closeScreen,
              ticketDetail: ticketDetail, // Pass the ticket details to the ResultSearch screen
            ),
          ),
        ).then((value) => closeScreen());
      } else {
        // Handle error
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load ticket details')),
        );
      }
    } catch (e) {
      // Handle exception
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Tra cứu vé",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
                child: Container(
              child: Column(
                children: [
                  // Text("Tra cứu vé", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
                  Text(
                    "Đưa mã QR vào đây để tìm vé",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade700),
                  ),
                  Text(
                    "Quét mã sẽ được thực hiện tự động",
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            )),
            Expanded(
                flex: 3,
                child: MobileScanner(
                  onDetect: (barcode) {
                    if (!isComplete) {
                      String code = barcode.barcodes.first.rawValue ?? "---";
                      isComplete = true;
                      fetchTicketDetails(code);
                    }
                  },
                )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: Text("Thực hiện bởi Duy Võ CFC"),
            )),
          ],
        ),
      ),
    );
  }
}
