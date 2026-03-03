import 'package:flutter/material.dart';
import '../models/event_model.dart';


class EventCard extends StatelessWidget {

  final EventModel event;
  final VoidCallback onTap;
  final bool showDelete;
  final VoidCallback? onDelete;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
    this.showDelete = false,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          event.title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Date: ${event.date}"),
        trailing: showDelete
            ? IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        )
            : const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
