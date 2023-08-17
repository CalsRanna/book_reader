import 'package:flutter/material.dart';

class ReaderTheme {
  final Color backgroundColor = Colors.white;
  final String backgroundImage = '';
  final EdgeInsets footerPadding = const EdgeInsets.only(
    bottom: 24,
    left: 16,
    right: 16,
    top: 0,
  );
  final TextStyle footerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  final EdgeInsets headerPadding = const EdgeInsets.only(
    bottom: 0,
    left: 16,
    right: 16,
    top: 59,
  );
  final TextStyle headerStyle = const TextStyle(
    fontSize: 10,
    height: 1,
  );
  final EdgeInsets pagePadding = const EdgeInsets.symmetric(
    horizontal: 16,
  );
  final TextStyle pageStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 36 / 18,
    letterSpacing: 0.2,
  );

  const ReaderTheme();
}
