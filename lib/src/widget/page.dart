import 'package:flutter/material.dart';

import 'footer.dart';
import 'header.dart';
import 'scope.dart';

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final color = BookReaderScope.of(context)!.backgroundColor;
    final cursor = BookReaderScope.of(context)!.cursor;
    final padding = BookReaderScope.of(context)!.pagePadding;
    final pages = BookReaderScope.of(context)!.pages;
    final style = BookReaderScope.of(context)!.pageStyle;
    final content = pages.isNotEmpty ? pages[cursor] : '暂无内容';
    return Scaffold(
      backgroundColor: color,
      body: GestureDetector(
        onTapUp: (details) => handleTap(context, details),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BookPageHeader(),
            Expanded(
              child: Container(
                margin: padding,
                width: double.infinity,
                child: Text(content, style: style),
              ),
            ),
            const BookPageFooter(),
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final position = details.globalPosition;
    if (position.dx < width ~/ 3) {
      BookReaderScope.of(context)!.onPageUp?.call();
    } else if (position.dx > width ~/ 3 * 2) {
      BookReaderScope.of(context)!.onPageDown?.call();
    } else {
      BookReaderScope.of(context)!.onOverlayInserted?.call();
    }
  }
}
