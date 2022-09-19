import 'package:flutter/material.dart';

import '../widget/scope.dart';

class Message {
  static show(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: BookReaderScope.of(context)!.duration,
      ),
    );
  }
}
