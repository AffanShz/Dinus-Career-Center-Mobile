import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Helper to push a route without context
  static Future<dynamic> push(Widget page) {
    if (navigatorKey.currentState != null) {
      return navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (_) => page),
      );
    }
    return Future.value(null);
  }
}
