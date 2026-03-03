

import 'package:flutter/foundation.dart';


class RegistrationRepository {

  RegistrationRepository._internal();


  static final RegistrationRepository _instance = RegistrationRepository._internal();
  factory RegistrationRepository() => _instance;


  final ValueNotifier<List<String>> registrations = ValueNotifier([]);


  void addRegistration(String registration) {
    registrations.value = [...registrations.value, registration];
  }


  void removeRegistration(String registration) {
    registrations.value = List.from(registrations.value)..remove(registration);
  }


  void clearRegistrations() {
    registrations.value = [];
  }
}