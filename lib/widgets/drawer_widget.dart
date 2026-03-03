import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import '../utils/constants.dart';

class DrawerWidget extends StatelessWidget {

  final bool isAdmin;

  const DrawerWidget({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: AppColors.primary,
            child: const Text(
              "Campus Event App",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          if (!isAdmin)
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Browse Events"),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.eventList);
              },
            ),

          if (isAdmin)
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("Add Event"),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.addEvent);
              },
            ),

          if (isAdmin)
            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text("Manage Events"),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.manageEvents);
              },
            ),

          const Spacer(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                      (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
