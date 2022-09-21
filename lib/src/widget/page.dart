import 'package:book_reader/src/widget/footer.dart';
import 'package:book_reader/src/widget/header.dart';
import 'package:book_reader/src/widget/scope.dart';
import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({
    super.key,
    required this.content,
    required this.name,
    required this.total,
    this.onOverlayOpened,
    this.onPageDown,
    this.onPageUp,
  });

  final String content;
  final String name;
  final int total;
  final void Function()? onOverlayOpened;
  final void Function()? onPageDown;
  final void Function()? onPageUp;

  @override
  Widget build(BuildContext context) {
    final padding = BookReaderScope.of(context)!.pagePadding;
    final style = BookReaderScope.of(context)!.pageStyle;
    return Scaffold(
      body: GestureDetector(
        onTapUp: (details) => handleTap(context, details),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookPageHeader(),
            Expanded(
              child: Container(
                margin: padding,
                child: Text(content, style: style),
              ),
            ),
            BookPageFooter(total: total),
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final position = details.globalPosition;
    if (position.dx < width ~/ 3) {
      onPageUp?.call();
    } else if (position.dx > width ~/ 3 * 2) {
      onPageDown?.call();
    } else {
      BookReaderScope.of(context)!.onOverlayInserted?.call();
    }
  }
}
