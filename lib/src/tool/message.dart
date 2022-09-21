import 'package:flutter/material.dart';

class Message {
  static show(
    BuildContext context, {
    Duration? duration,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(milliseconds: 200),
      ),
    );
  }
}
