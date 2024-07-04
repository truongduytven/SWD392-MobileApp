import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swd392/Data/ticket_detail.dart';
import 'package:swd392/Search/result_Search.dart';

class ScanTicketPage extends StatefulWidget {
  final String tripID;
  final String seatCode;
  const ScanTicketPage({super.key, required this.tripID, required this.seatCode});

  @override
  State<ScanTicketPage> createState() => _ScanTicketPageState();
}

class _ScanTicketPageState extends State<ScanTicketPage> {
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
        
        // Check if tripID and seatCode match
        if (ticketDetail.tripID == widget.tripID && ticketDetail.seatCode == widget.seatCode) {
          // Close the loading modal
          Navigator.of(context).pop();

          // Navigate to the result screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultSearch(
                isCheckTicket: true,
                code: code,
                closeScreen: closeScreen,
                ticketDetail: ticketDetail, // Pass the ticket details to the ResultSearch screen
              ),
            ),
          ).then((value) => closeScreen());
        } else {
          // Close the loading modal
          Navigator.of(context).pop();
          // Show toast message
          Fluttertoast.showToast(
            msg: "Số ghế hoặc chuyến đi không hợp lệ. Vui lòng kiểm tra lại!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          // Allow the user to scan again
          isComplete = false;
        }
      } else {
        // Handle error
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load ticket details')),
        );
        // Allow the user to scan again
        isComplete = false;
      }
    } catch (e) {
      // Handle exception
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      // Allow the user to scan again
      isComplete = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          "Tra cứu vé",
          style: TextStyle(
            color: Colors.white,
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
              child: Text("Thực hiện bởi The Bus Journey"),
            )),
          ],
        ),
      ),
    );
  }
}
