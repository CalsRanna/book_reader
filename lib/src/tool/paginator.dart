import 'package:book_reader/book_reader.dart';
import 'package:flutter/material.dart';

/// Paginator is a class used to paginate the content into different pages.
class Paginator {
  final Size size;
  final ReaderTheme theme;
  final TextPainter _painter;

  /// Paginator is a class used to paginate the content into different pages.
  ///
  /// [size] is the available size of the content, and [theme] has some default styles.
  Paginator({required this.size, required this.theme})
      : _painter = TextPainter(
          strutStyle: StrutStyle(
            fontSize: theme.pageStyle.fontSize,
            forceStrutHeight: true,
            height: theme.pageStyle.height,
          ),
        );

  /// Paginate the content into different pages, each page is a [TextSpan].
  List<String> paginate(String content) {
    try {
      // 零宽字符填充内容，用于覆盖默认换行逻辑，会导致分页时长提高5-6倍
      // content = content.split('').join('\u200B');
      // 填充全角空格，用于首行缩进
      // content = content.split('\n').join('\n\u2003\u2003');
      var offset = 0;
      List<String> pages = [];
      while (offset < content.length - 1) {
        var start = offset;
        var end = content.length - 1;
        var middle = ((start + end) / 2).ceil();
        while (end - start > 1) {
          var page = content.substring(offset, middle);
          // 如果新的一页以换行符开始，删除这个换行符
          if (page.startsWith('\n')) {
            offset += 1;
          }
          if (_layout(page)) {
            start = middle;
            middle = ((start + end) / 2).ceil();
          } else {
            end = middle;
            middle = ((start + end) / 2).ceil();
          }
        }
        if (middle == content.length - 1) {
          // substring不包含end，所以当需要截取后面所有字符串时，end应设为null
          var page = content.substring(offset);
          // 最后一页填充换行符以撑满整个屏幕
          while (_layout('$page\n')) {
            page += '\n';
          }
          pages.add(page);
        } else {
          var page = content.substring(offset, middle);
          // 如果最后一次分页溢出，则减少一个字符，因为计算到后面已经在相邻位置进行截取了。
          if (!_layout(page)) {
            middle--;
            page = content.substring(offset, middle);
          }
          pages.add(page);
        }
        offset = middle;
      }
      return pages;
    } catch (error) {
      throw PaginationException(error.toString());
    }
  }

  /// Whether the text can be paint properly in the available area. If
  /// the return value is [true], means still in the available size,
  /// and [false] means not.
  bool _layout(String text) {
    try {
      final direction = theme.textDirection;
      final span = _build(text);
      _painter.text = span;
      _painter.textDirection = direction;
      _painter.layout(maxWidth: size.width);
      return _painter.size.height <= size.height;
    } on Exception catch (error) {
      throw PaginationException(error.toString());
    }
  }

  /// Build a [TextSpan] from the given text. Which will split into multi paragraphs.
  TextSpan _build(String text) {
    try {
      // 通过换行实现段间距，会导致分页时长提高1倍左右，会有较明显的卡顿感
      // final paragraphs = text.split('\n');
      // final length = paragraphs.length;
      // List<InlineSpan> children = [];
      // final style = theme.pageStyle;
      // final height = style.height! * 0.25;
      // final paragraphStyle = style.copyWith(height: height);
      // for (var i = 0; i < length; i++) {
      //   children.add(TextSpan(text: '${paragraphs[i]}\n', style: style));
      //   if (i < length - 1) {
      //     children.add(TextSpan(text: '\n', style: paragraphStyle));
      //   }
      // }
      // return TextSpan(children: children);
      return TextSpan(text: text, style: theme.pageStyle);
    } catch (error) {
      throw PaginationException(error.toString());
    }
  }
}

/// Pagination exception.
class PaginationException implements Exception {
  PaginationException(this.message);

  final String message;
}
