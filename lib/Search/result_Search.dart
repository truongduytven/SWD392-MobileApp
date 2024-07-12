import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swd392/Data/ticket_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class ResultSearch extends StatefulWidget {
  final bool isCheckTicket;
  final String code;
  final Function() closeScreen;
  final TicketDetail ticketDetail;

  const ResultSearch({
    Key? key,
    required this.isCheckTicket,
    required this.code,
    required this.ticketDetail,
    required this.closeScreen,
  }) : super(key: key);

  @override
  _ResultSearchState createState() => _ResultSearchState();
}

class _ResultSearchState extends State<ResultSearch> {
  String token = '';

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

  void confirmCheckTicket() async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận"),
          content: Text("Bạn có chắc chắn muốn xác nhận soát vé?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Huỷ",
                style: TextStyle(color: Colors.orange),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.orange),
              ),
              child: Text(
                "Xác nhận",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirm) {
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
        Response response = await put(
          Uri.parse(
              'https://ticket-booking-swd392-project.azurewebsites.net/ticket-detail-management/managed-ticket-details/ticket-verification/${widget.code}'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          // Parse the response
          await saveTicketDetails(widget.ticketDetail);
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Soát vé thành công!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Xác nhận soát vé không thành công'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xác nhận soát vé không thành công'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> saveTicketDetails(TicketDetail ticketDetail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? saveServicesDataString = prefs.getString('SaveServicesData');
    Map<String, dynamic> saveServicesData;

    if (saveServicesDataString != null) {
      saveServicesData = json.decode(saveServicesDataString);
    } else {
      saveServicesData = {};
    }

    String tripID = ticketDetail.tripID;
    List<dynamic> tickets = saveServicesData[tripID]?['Tickets'] ?? [];

    Map<String, dynamic> newTicket = {
      'SeatCode': ticketDetail.seatCode,
      'Name': ticketDetail.name,
      'Services': ticketDetail.services.map((service) {
        return {
          'TicketDetailServiceID': service.ticketDetailServiceID,
          'ServiceName': service.serviceName,
          'Quantity': service.quantity,
          'TotalPrice': service.totalPrice,
          'StationID': service.stationID,
          'HasCheck': service.hasCheck,
          'ImageUrl': service.imageUrl,
        };
      }).toList()
    };

    tickets.add(newTicket);

    saveServicesData[tripID] = {
      'TripID': tripID,
      'Tickets': tickets,
    };

    await prefs.setString('SaveServicesData', json.encode(saveServicesData));
  }

  Map<String, dynamic>? getSavedServicesData() {
    SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
    String? saveServicesDataString = prefs.getString('SaveServicesData');
    if (saveServicesDataString != null) {
      return json.decode(saveServicesDataString);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.closeScreen();
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
          ),
        ),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Mã vé hợp lệ",
                            style: TextStyle(
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                          ),
                          Container(
                            child: QrImageView(
                              data: widget.ticketDetail.qrCodeImage,
                              size: 150,
                              version: QrVersions.auto,
                            ),
                          ),
                          Text(
                            "Mã vé là: ${widget.code}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Thông tin vé",
                        style: TextStyle(
                          color: Colors.orange.shade600,
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Trạng thái: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.ticketDetail.status,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mã ghế: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.ticketDetail.seatCode,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tên: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.ticketDetail.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Số điện thoại: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.ticketDetail.phoneNumber,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Giờ đi: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.ticketDetail.startTime,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ngày đi: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.ticketDetail.startDay,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tuyến: ",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            widget.ticketDetail.route,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 1,
                              wordSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Danh sách dịch vụ đã mua:",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.orange.shade600,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.ticketDetail.services
                            .length, // Replace with your actual list size
                        itemBuilder: (context, index) {
                          var service = widget.ticketDetail.services[index];
                          // Replace with your notification item widget
                          return Container(
                            width: double.infinity,
                            height: 150,
                            margin: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Image.network(
                                        service.imageUrl,
                                        height: 100,
                                        width: 100,
                                      )),
                                ),
                                Container(
                                  width: 200,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${service.serviceName}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                      Text(
                                        "Số lượng: ${service.quantity}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                      Text(
                                        "Trạm: ${service.station}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                      Text(
                                        "Tổng tiền: ${service.totalPrice}đ",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                      Text(
                                        service.hasCheck ? "Đã sử dụng" : "Chưa sử dụng",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: service.hasCheck
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 50,)
                    ],
                  ),
                )
              ],
            ),
          ),
          if (widget.isCheckTicket)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      confirmCheckTicket();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Xác nhận soát vé",
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
