import 'package:flutter/material.dart';

class ScaffoldHandler {
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void showInfoSnackBar({
    required String message,
  }) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1600),
    ));
  }

  void showErrorScaffold({required String message}) {
    scaffoldKey.currentState?.showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(milliseconds: 1600),
      backgroundColor: Colors.redAccent,
    ));
  }
}
