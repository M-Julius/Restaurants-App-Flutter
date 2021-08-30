import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(String routeName, Object arguments) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static toRoute(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  static replacement(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  static back() => navigatorKey.currentState?.pop();
}
