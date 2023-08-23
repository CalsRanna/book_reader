import 'package:book_reader/book_reader.dart';
import 'package:flutter/material.dart';

/// Paginator is a class used to paginate the content into different pages.
class Paginator {
  final Size size;
  final ReaderTheme theme;

  /// Paginator is a class used to paginate the content into different pages.
  ///
  /// [size] is the available size of the content, and [theme] has some default styles.
  const Paginator({required this.size, required this.theme});

  /// Paginate the content into different pages, each page is a [TextSpan].
  List<TextSpan> paginate(String content) {
    content = content.split('').join('\u200B'); // 零宽字符填充内容，用于覆盖默认换行逻辑
    content = content.split('\n').join('\n\u2003\u2003'); // 填充全角空格，用于首行缩进
    var offset = 0;
    List<TextSpan> pages = [];
    while (offset < content.length - 1) {
      var start = offset;
      var end = content.length - 1;
      var middle = ((start + end) / 2).ceil();
      for (var i = 0; i < 16; i++) {
        if (_layout(content.substring(offset, middle))) {
          start = middle;
          middle = ((start + end) / 2).ceil();
        } else {
          end = middle;
          middle = ((start + end) / 2).ceil();
        }
      }
      if (middle == content.length - 1) {
        pages.add(_build(content.substring(offset)));
      } else {
        pages.add(_build(content.substring(offset, middle)));
      }
      offset = middle;
    }
    return pages;
  }

  /// Whether the text can be paint properly in the available area. If
  /// the return value is [true], means still in the available size,
  /// and [false] means not.
  bool _layout(String text) {
    final direction = theme.textDirection;
    final painter = TextPainter(text: _build(text), textDirection: direction);
    painter.layout(maxWidth: size.width);
    return painter.size.height <= size.height;
  }

  /// Build a [TextSpan] from the given text. Which will split into multi paragraphs.
  TextSpan _build(String text) {
    final paragraphs = text.split('\n');
    final length = paragraphs.length;
    List<InlineSpan> children = [];
    final style = theme.pageStyle;
    final height = style.height! * 0.25;
    final paragraphStyle = style.copyWith(height: height);
    for (var i = 0; i < length; i++) {
      children.add(TextSpan(text: '${paragraphs[i]}\n', style: style));
      if (i < length - 1) {
        children.add(TextSpan(text: '\n', style: paragraphStyle));
      }
    }
    return TextSpan(children: children);
  }
}
