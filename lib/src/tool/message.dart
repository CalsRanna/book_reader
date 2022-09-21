import 'package:flutter/material.dart';

class Message {
  static show(
    BuildContext context, {
    Duration? duration,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: duration ?? const Duration(milliseconds: 200),
        shape: const StadiumBorder(),
      ),
    );
  }
}
