import 'package:flutter/material.dart';


class EventRepository {
  static final EventRepository _instance = EventRepository._internal();
  factory EventRepository() => _instance;
  EventRepository._internal();

  ValueNotifier<List<Map<String, String>>> events = ValueNotifier([]);
}