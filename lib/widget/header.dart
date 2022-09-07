import 'package:flutter/material.dart';

class BookPageHeader extends StatelessWidget {
  const BookPageHeader({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.style = const TextStyle(color: Colors.black, fontSize: 10),
    required this.text,
  });

  final EdgeInsets padding;
  final TextStyle style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}
