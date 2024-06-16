import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:swd392/Search/result_Search.dart';

class SearchTicketPage extends StatefulWidget {
  const SearchTicketPage({super.key});

  @override
  State<SearchTicketPage> createState() => _SearchTicketPageState();
}

class _SearchTicketPageState extends State<SearchTicketPage> {
  bool isComplete = false;

  void closeScreen() {
    isComplete = false;
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultSearch(
                            closeScreen: closeScreen,
                            code: code,
                          ), // Pass the QR code data to ResultSearch if needed
                        ),
                      ).then((value) => closeScreen());
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
