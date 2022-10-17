import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RouteController {
  RouteController._();
  static RouteController instance = RouteController._();

  ///Push the given route onto the navigator.
  void push({required Widget page}) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
  
  ///Push the given route onto the navigator, and then remove all the previous routes until the predicate returns true.
  void pushAndRemoveUntil({required Widget page}) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context)=> page), (route) => false,
    );
  }

  ///Pop the top-most route off the navigator.
  void pop() {
    navigatorKey.currentState?.pop();
  }

  ///snackbar message
  void showSnackBar({
    required String message,
    int milliseconds = 500,
    Color backgroundColor = Colors.black,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: milliseconds),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(snackBar);
  }
}
