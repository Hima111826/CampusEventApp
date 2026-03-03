import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/constants.dart';
import '../../services/api_service.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Events",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 6,
        iconTheme: const IconThemeData(color: Colors.white),
      ),


      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ApiService.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error fetching events: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final eventsData = snapshot.data ?? [];

          if (eventsData.isEmpty) {
            return const Center(
              child: Text(
                "No events available",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            );
          }


          final events = eventsData.map((e) => EventModel.fromJson(e)).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  title: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2C),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: Color(0xFF6C63FF)),
                        const SizedBox(width: 6),
                        Text(
                          event.date,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.eventDetail,
                      arguments: event,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}