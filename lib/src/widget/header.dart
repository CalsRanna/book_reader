import 'package:book_reader/src/widget/scope.dart';
import 'package:flutter/material.dart';

class BookPageHeader extends StatelessWidget {
  const BookPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = BookReaderScope.of(context)!.headerPadding;
    final color = BookReaderScope.of(context)!.textColor;
    final style = TextStyle(color: color, fontSize: 10, height: 1);
    var text = BookReaderScope.of(context)!.name;
    if (BookReaderScope.of(context)!.cursor > 0 &&
        BookReaderScope.of(context)!.title != null) {
      text = BookReaderScope.of(context)!.title!;
    }
    return Container(
      color: Colors.transparent,
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
