

import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../services/api_service.dart';

class ViewRegistrationsScreen extends StatefulWidget {
  const ViewRegistrationsScreen({Key? key}) : super(key: key);

  @override
  State<ViewRegistrationsScreen> createState() => _ViewRegistrationsScreenState();
}

class _ViewRegistrationsScreenState extends State<ViewRegistrationsScreen> {
  List<Map<String, dynamic>> registrations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRegistrations();
  }

  Future<void> fetchRegistrations() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await ApiService.getRegistrations();
      setState(() {
        registrations = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to fetch registrations: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteRegistration(String studentEmail, String eventId) async {
    try {
      await ApiService.deleteRegistration(studentEmail: studentEmail, eventId: eventId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );
      fetchRegistrations();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete registration: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Registrations",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : registrations.isEmpty
          ? const Center(
        child: Text(
          "No registrations yet",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: registrations.length,
        itemBuilder: (context, index) {
          final reg = registrations[index];
          final studentEmail = reg['student_email'] ?? '';
          final eventTitle = reg['event_title'] ?? '';
          final eventId = reg['event_id'] ?? '';

          return Card(
            color: AppColors.white.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              title: Text(
                "$studentEmail → $eventTitle",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
          );
        },
      ),
    );
  }
}