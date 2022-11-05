import 'package:flutter/material.dart';

class Message {
  static show(
    BuildContext context, {
    Color? color,
    Duration? duration,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: duration ?? const Duration(milliseconds: 200),
        shape: const StadiumBorder(),
      ),
    );
  }
}
