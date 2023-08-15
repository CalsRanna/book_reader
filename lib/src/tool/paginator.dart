import 'package:flutter/material.dart';

class Paginator {
  const Paginator({required this.size, required this.style});

  final Size size;
  final TextStyle style;

  List<String> paginate(String content) {
    var offset = 0;
    List<String> pages = [];
    while (offset < content.length - 1) {
      var start = offset;
      var end = content.length;
      var middle = ((start + end) ~/ 2);
      for (var i = 0; i < 16; i++) {
        if (_layout(content.substring(offset, middle))) {
          if (middle <= start || middle >= end) {
            break;
          }
          start = middle;
          middle = ((start + end) ~/ 2);
        } else {
          end = middle;
          middle = ((start + end) ~/ 2);
        }
      }
      pages.add(content.substring(offset, middle));
      offset = middle;
    }
    if (pages.isNotEmpty) {
      var last = pages.last;
      if (_layout('$last${content[content.length - 1]}')) {
        pages.last = '$last${content[content.length - 1]}';
      } else {
        pages.add(content[content.length - 1]);
      }
    }
    return pages;
  }

  /// Whether the text can be paint properly in the available area. If
  /// the return value is [true], means still in the available size,
  /// and [false] means not.
  bool _layout(String text) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    painter.layout(maxWidth: size.width);
    if (painter.size.height > size.height) {
      return false;
    } else {
      return true;
    }
  }
}
