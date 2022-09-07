import 'package:flutter/material.dart';

class Paginator {
  const Paginator({required this.size});

  final Size size;

  List<String> paginate(String content) {
    var offset = 0;
    List<String> pages = [];
    while (offset < content.length - 1) {
      var start = offset;
      var end = content.length;
      var middle = ((start + end) / 2).ceil();
      for (var i = 0; i < 20; i++) {
        if (_layout(content.substring(offset, middle))) {
          if (middle <= start || middle >= end) {
            break;
          }
          start = middle;
          middle = ((start + end) / 2).ceil();
        } else {
          end = middle;
          middle = ((start + end) / 2).ceil();
        }
      }
      pages.add(content.substring(offset, middle));
      offset = middle;
    }
    return pages;
  }

  bool _layout(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text),
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: size.width);
    if (painter.didExceedMaxLines || painter.size.height > size.height) {
      return false;
    } else {
      return true;
    }
  }
}
