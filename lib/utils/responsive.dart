import 'package:flutter/material.dart';

class Responsive {


  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }


  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }


  static bool isMobile(BuildContext context) {
    return width(context) < 600;
  }


  static bool isTablet(BuildContext context) {
    return width(context) >= 600 && width(context) < 1024;
  }


  static bool isDesktop(BuildContext context) {
    return width(context) >= 1024;
  }


  static EdgeInsets screenPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24);
    } else {
      return const EdgeInsets.symmetric(horizontal: 200, vertical: 30);
    }
  }


  static double cardWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return width(context) * 0.7;
    } else {
      return width(context) * 0.5;
    }
  }
}
