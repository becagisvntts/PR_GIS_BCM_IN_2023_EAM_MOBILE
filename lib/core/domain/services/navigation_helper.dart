import 'package:flutter/material.dart';

class NavigationHelper {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> push(dynamic route) async {
    return Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
            builder: (context) => route,
            settings: RouteSettings(name: route.runtimeType.toString())));
  }

  static Future<dynamic> pushReplacement(dynamic route) async {
    if (route != ModalRoute.of(navigatorKey.currentContext!)) {
      return Navigator.pushReplacement(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (context) => route,
              settings: RouteSettings(name: route.runtimeType.toString())));
    }
  }

  static void pop({String? message}) {
    return Navigator.of(navigatorKey.currentContext!).pop(message);
  }

  static popUtil(String routeName) {
    Navigator.of(navigatorKey.currentContext!)
        .popUntil(ModalRoute.withName(routeName));
  }
}
