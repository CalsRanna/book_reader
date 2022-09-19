import 'package:book_reader/src/widget/scope.dart';
import 'package:flutter/material.dart';

class BookPageHeader extends StatelessWidget {
  const BookPageHeader({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: BookReaderScope.of(context)!.textColor,
      fontSize: 10,
      height: 1,
    );
    var text = BookReaderScope.of(context)!.name;
    if (BookReaderScope.of(context)!.cursor > 0 &&
        BookReaderScope.of(context)!.title != null) {
      text = BookReaderScope.of(context)!.title!;
    }
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
