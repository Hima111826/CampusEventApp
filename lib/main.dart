import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/student/event_list_screen.dart';
import 'screens/student/event_detail_screen.dart';
import 'screens/student/feedback_screen.dart';
import 'screens/admin/add_event_screen.dart';
import 'screens/admin/manage_events_screen.dart';
import 'screens/admin/view_registrations_screen.dart';
import 'utils/constants.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Management',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => SplashScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.studentDashboard: (context) => StudentDashboard(),
        AppRoutes.adminDashboard: (context) => AdminDashboard(),
        AppRoutes.eventList: (context) => EventListScreen(),
        AppRoutes.eventDetail: (context) => EventDetailScreen(),
        AppRoutes.addEvent: (context) => AddEventScreen(),
        AppRoutes.manageEvents: (context) => ManageEventsScreen(),
        AppRoutes.viewRegistrations: (context) => ViewRegistrationsScreen(),
        AppRoutes.feedback: (context) => FeedbackScreen(),
      },
    );
  }
}
