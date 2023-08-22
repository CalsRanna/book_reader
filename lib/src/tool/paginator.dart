import 'package:flutter/material.dart';

class Paginator {
  const Paginator({
    this.direction = TextDirection.ltr,
    required this.size,
    required this.style,
  });

  final TextDirection direction;
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
    final paragraphs = text.split('\n');
    final length = paragraphs.length;
    List<InlineSpan> children = [];
    for (var i = 0; i < length; i++) {
      children.add(TextSpan(text: paragraphs[i], style: style));
      if (i < length - 1) {
        final height = (style.height! - 0.5);
        final paragraphStyle = style.copyWith(height: height);
        children.add(
          TextSpan(text: '\n\n', style: paragraphStyle),
        );
      }
    }
    final painter = TextPainter(
      text: TextSpan(children: children),
      textDirection: direction,
    );
    painter.layout(maxWidth: size.width);
    return painter.size.height <= size.height;
  }
}
