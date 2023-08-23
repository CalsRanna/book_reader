import 'package:flutter/material.dart';

class ReaderTheme {
  Color backgroundColor = Colors.white;
  String backgroundImage = '';
  EdgeInsets footerPadding = const EdgeInsets.only(
    bottom: 24,
    left: 16,
    right: 16,
    top: 4,
  );
  TextStyle footerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  EdgeInsets headerPadding = const EdgeInsets.only(
    bottom: 4,
    left: 16,
    right: 16,
    top: 43,
  );
  TextStyle headerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  EdgeInsets pagePadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );
  TextStyle pageStyle = const TextStyle(
    inherit: false,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 40 / 18,
    letterSpacing: 0.2,
  );
  TextDirection textDirection = TextDirection.ltr;

  ReaderTheme copyWith({
    Color? backgroundColor,
    String? backgroundImage,
    EdgeInsets? footerPadding,
    TextStyle? footerStyle,
    EdgeInsets? headerPadding,
    TextStyle? headerStyle,
    EdgeInsets? pagePadding,
    TextStyle? pageStyle,
    TextDirection? textDirection,
  }) {
    return ReaderTheme()
      ..backgroundColor = backgroundColor ?? this.backgroundColor
      ..backgroundImage = backgroundImage ?? this.backgroundImage
      ..footerPadding = footerPadding ?? this.footerPadding
      ..footerStyle = footerStyle ?? this.footerStyle
      ..headerPadding = headerPadding ?? this.headerPadding
      ..headerStyle = headerStyle ?? this.headerStyle
      ..pagePadding = pagePadding ?? this.pagePadding
      ..pageStyle = pageStyle ?? this.pageStyle
      ..textDirection = textDirection ?? this.textDirection;
  }
}
