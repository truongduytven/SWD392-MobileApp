import 'dart:convert';
import 'package:http/http.dart' as http;

class MyApi {
  final String baseUrl = "https://ticket-booking-swd392-project.azurewebsites.net";

  Future<dynamic> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl/data'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}