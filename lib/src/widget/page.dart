import 'dart:math';

import 'package:flutter/material.dart';

import 'scope.dart';

class BookPage extends StatelessWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cursor = BookReaderScope.of(context)!.cursor;
    final padding = BookReaderScope.of(context)!.pagePadding;
    final pages = BookReaderScope.of(context)!.pages;
    final style = BookReaderScope.of(context)!.pageStyle;
    final content = pages.isNotEmpty ? pages[cursor] : '暂无内容';
    return Scaffold(
      // backgroundColor: color,
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

class BookPageHeader extends StatelessWidget {
  const BookPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final color = BookReaderScope.of(context)!.textColor;
    final padding = BookReaderScope.of(context)!.headerPadding;
    final name = BookReaderScope.of(context)!.name;
    final style = TextStyle(color: color, fontSize: 10, height: 1);
    var text = name;
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

class BookPageFooter extends StatelessWidget {
  const BookPageFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final current = BookReaderScope.of(context)!.cursor + 1;
    final now = DateTime.now();
    final padding = BookReaderScope.of(context)!.footerPadding;
    final pages = BookReaderScope.of(context)!.pages;
    final progress = BookReaderScope.of(context)!.progress * 100;
    final style = TextStyle(
      color: BookReaderScope.of(context)!.textColor,
      fontSize: 10,
      height: 1,
    );
    List<Widget> left = [const Text('获取中')];
    if (pages.isNotEmpty) {
      left = [
        Text('$current/${pages.length}'),
        const SizedBox(width: 8),
        Text('${progress.toStringAsFixed(2)}%'),
      ];
    }
    return Container(
      color: Colors.transparent,
      padding: padding,
      child: DefaultTextStyle.merge(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
        child: Row(
          children: [
            ...left,
            const Expanded(child: SizedBox()),
            Text('${now.hour}:${now.minute.toString().padLeft(2, '0')}'),
            Transform.rotate(
              angle: pi / 2,
              child: const Icon(Icons.battery_5_bar_outlined, size: 10),
            ),
          ],
        ),
      ),
    );
  }
}
