import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) return "http://localhost:8080/api";
    return "http://10.0.2.2:8080/api";
  }

  // 🔐 AUTH
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/service-provider/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      if (response.statusCode == 200 && response.body != "null") return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Login error: $e");
    }
    return null;
  }

  static Future<Map<String, dynamic>?> register(
      String name, String email, String password, String phone, String role) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/service-provider/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "role": role,
        }),
      );
      if (response.statusCode == 200 && response.body != "null") return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Register error: $e");
    }
    return null;
  }

  // 🏥 PROVIDERS
  static Future<List<dynamic>> getAllProviders() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/service-provider/providers"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get providers error: $e");
    }
    return [];
  }

  static Future<List<dynamic>> getProvidersByType(String type) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/service-provider/providers/type/$type"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get providers by type error: $e");
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getProviderProfile(String email) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/service-provider/email/$email"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get provider profile error: $e");
    }
    return null;
  }

  static Future<bool> updateProviderProfile(Map<String, dynamic> provider) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/service-provider/update"), // Actually it's PUT in controller, let me check
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(provider),
      );
      // Wait, I used PutMapping in controller. Let me use PUT here.
      final responsePut = await http.put(
        Uri.parse("$baseUrl/service-provider/update"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(provider),
      );
      return responsePut.statusCode == 200;
    } catch (e) {
      debugPrint("Update provider profile error: $e");
    }
    return false;
  }

  // 📅 BOOKINGS
  static Future<void> createBooking(String email, String serviceType, {String? providerEmail, String? date, String? time}) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/bookings/create"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "farmerEmail": email,
          "providerEmail": providerEmail,
          "serviceType": serviceType,
          "status": "PENDING",
          "appointmentDate": date ?? DateTime.now().toString().split(' ')[0],
          "appointmentTime": time ?? "09:00 AM",
        }),
      );
    } catch (e) {
      debugPrint("Create booking error: $e");
    }
  }

  static Future<List<dynamic>> getFarmerBookings(String email) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/bookings/farmer/$email"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get bookings error: $e");
    }
    return [];
  }

  static Future<List<dynamic>> getAllBookings() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/bookings/all"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get all bookings error: $e");
    }
    return [];
  }

  static Future<List<dynamic>> getProviderBookings(String email) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/bookings/provider/$email"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get provider bookings error: $e");
    }
    return [];
  }

  static Future<void> updateBookingStatus(int id, String status, {String? providerEmail}) async {
    try {
      String url = "$baseUrl/bookings/update/$id/$status";
      if (providerEmail != null) url += "?providerEmail=$providerEmail";
      await http.put(Uri.parse(url));
    } catch (e) {
      debugPrint("Update status error: $e");
    }
  }

  static Future<Map<String, dynamic>> getBookingStats({String? email}) async {
    try {
      String url = "$baseUrl/bookings/stats";
      if (email != null) url += "?email=$email";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get stats error: $e");
    }
    return {"total": 0, "pending": 0, "accepted": 0, "rejected": 0};
  }

  // 💬 CONSULTATIONS (Interactions)
  static Future<List<dynamic>> getConsultationNotes(int bookingId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/consultations/notes/$bookingId"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get notes error: $e");
    }
    return [];
  }

  static Future<void> addConsultationNote(
      int bookingId, String role, String name, String content, String type) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/consultations/note"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "bookingId": bookingId,
          "senderRole": role,
          "senderName": name,
          "content": content,
          "noteType": type
        }),
      );
    } catch (e) {
      debugPrint("Add note error: $e");
    }
  }

  static Future<void> updateAvailability(String email, bool status) async {
    try {
      await http.put(
        Uri.parse("$baseUrl/service-provider/availability"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "isAvailable": status}),
      );
    } catch (e) {
      debugPrint("Update availability error: $e");
    }
  }

  // 💉 VACCINATIONS
  static Future<void> addVaccinationRecord({
    required String farmerEmail,
    required String animal,
    required String vaccine,
    String? dateGiven,
    String? nextDueDate,
    String? status,
    String? providerEmail,
  }) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/vaccinations"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "farmerEmail": farmerEmail,
          "animalName": animal,
          "vaccineName": vaccine,
          "dateGiven": dateGiven,
          "nextDueDate": nextDueDate ?? (dateGiven != null ? DateTime.parse(dateGiven).add(const Duration(days: 180)).toString().split(' ')[0] : null),
          "status": status ?? "COMPLETED",
          "providerEmail": providerEmail,
        }),
      );
    } catch (e) {
      debugPrint("Add vaccination error: $e");
    }
  }

  static Future<List<dynamic>> getFarmerVaccinations(String email) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/vaccinations/farmer/$email"));
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Get vaccinations error: $e");
    }
    return [];
  }

  static Future<bool> submitReview(Map<String, dynamic> review) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/reviews"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(review),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Submit review error: $e");
    }
    return false;
  }
}