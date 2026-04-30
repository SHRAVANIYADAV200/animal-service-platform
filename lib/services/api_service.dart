import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080/api/service-provider";

  // 🔐 LOGIN API
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200 && response.body != "null") {
      return jsonDecode(response.body);
    }
    return null;
  }

  // 📝 REGISTER API (ADD THIS BELOW LOGIN)
  static Future<Map<String, dynamic>?> register(
      String name,
      String email,
      String password,
      String phone,
      String role,
      ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,
        "role": role,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // 🟢 CREATE BOOKING
  static Future<void> createBooking(String email, String service) async {
    await http.post(
      Uri.parse("http://10.0.2.2:8080/api/bookings/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "farmerEmail": email,
        "serviceType": service,
      }),
    );
  }

  static Future<List<dynamic>> getFarmerBookings(String email) async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/bookings/farmer/$email"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  static Future<void> updateStatus(int id, String status) async {
    await http.put(
        Uri.parse("http://10.0.2.2:8080/api/bookings/update/$id/$status"),
    );
  }

  static Future<List<dynamic>> getAllBookings() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/bookings/all"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }



  // 🟢 GET ALL BOOKINGS
  static Future<List<dynamic>> getBookings() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8080/api/bookings/all"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }


}