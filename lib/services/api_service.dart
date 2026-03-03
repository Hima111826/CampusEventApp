

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = "http://10.173.240.31:5000";

  static const Duration timeoutDuration = Duration(seconds: 10);


  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      )
          .timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final data = json.decode(response.body);
        return {
          "status": "error",
          "message": data['message'] ?? "Login failed",
        };
      }
    } catch (e) {
      return {"status": "error", "message": "Server error: $e"};
    }
  }


  static Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      final response =
      await http.get(Uri.parse("$baseUrl/events")).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception("Failed to load events: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch events: $e");
    }
  }


  static Future<Map<String, dynamic>> addEvent({
    required String title,
    required String description,
    required String date,
  }) async {
    try {
      final response = await http
          .post(
        Uri.parse("$baseUrl/events"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "description": description,
          "date": date,
        }),
      )
          .timeout(timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to add event: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to add event: $e");
    }
  }


  static Future<Map<String, dynamic>> editEvent({
    required String eventId,
    required String title,
    required String description,
    required String date,
  }) async {
    try {
      final response = await http
          .put(
        Uri.parse("$baseUrl/events/$eventId"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "title": title,
          "description": description,
          "date": date,
        }),
      )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to edit event: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to edit event: $e");
    }
  }


  static Future<Map<String, dynamic>> deleteEvent({required String eventId}) async {
    try {
      final response = await http
          .delete(
        Uri.parse("$baseUrl/events/$eventId"),
        headers: {"Content-Type": "application/json"},
      )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to delete event: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to delete event: $e");
    }
  }


  static Future<void> registerEvent({
    required String studentEmail,
    required int eventId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rsvp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': studentEmail,
        'event_id': eventId,
      }),
    );

    if (response.statusCode != 201) {
      final msg = jsonDecode(response.body)['message'];
      throw Exception(msg);
    }
  }


  static Future<List<Map<String, dynamic>>> getRegistrations() async {
    try {
      final response =
      await http.get(Uri.parse("$baseUrl/rsvp")).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception("Failed to fetch registrations: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to fetch registrations: $e");
    }
  }


  static Future<Map<String, dynamic>> deleteRegistration({
    required String studentEmail,
    required String eventId,
  }) async {
    try {

      final response = await http.delete(
        Uri.parse("$baseUrl/rsvp/$eventId"),
        headers: {"Content-Type": "application/json"},
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to delete registration: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to delete registration: $e");
    }
  }



  static Future<void> submitFeedback({
    required String email,
    required int eventId,
    required int rating,
    required String comment,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/feedback"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "event_id": eventId,
        "rating": rating,
        "comment": comment,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message'] ?? "Failed to submit feedback");
    }
  }
}
