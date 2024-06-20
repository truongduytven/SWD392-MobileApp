import 'package:flutter/material.dart';

class ListTicketPage extends StatefulWidget {
  const ListTicketPage({super.key});

  @override
  _ListTicketPageState createState() => _ListTicketPageState();
}

class _ListTicketPageState extends State<ListTicketPage> {
  String filter = 'All';

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
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  'Chuyến: TP Hồ Chí Minh - Bến Tre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '20:00 - 23:00 18/07/2024',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.orange[50],
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.orange,
                          width: 0.5), // Smaller width and orange color
                      borderRadius: BorderRadius.circular(10.0),
                    )),
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
                  onPressed: () {},
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                        ),
                      borderRadius: BorderRadius.circular(10.0)
                      ),
                    child: ListTile(
                      title: Text('Số ghế: ' + filteredTickets[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
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

  Ticket({required this.title, required this.isChecked});
}

final List<Ticket> tickets = [
  Ticket(title: 'A01', isChecked: true),
  Ticket(title: 'A02', isChecked: false),
  Ticket(title: 'A03', isChecked: true),
  Ticket(title: 'A04', isChecked: false),
  Ticket(title: 'A05', isChecked: true),
  Ticket(title: 'A06', isChecked: false),
  Ticket(title: 'A07', isChecked: true),
  Ticket(title: 'A08', isChecked: false),
  Ticket(title: 'A09', isChecked: true),
  Ticket(title: 'A10', isChecked: false),
  Ticket(title: 'B01', isChecked: true),
  Ticket(title: 'B02', isChecked: false),
  Ticket(title: 'B03', isChecked: true),
  Ticket(title: 'B04', isChecked: false),
  Ticket(title: 'B05', isChecked: true),
  Ticket(title: 'B06', isChecked: false),
];
