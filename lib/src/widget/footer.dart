import 'dart:math';

import 'package:flutter/material.dart';

import 'scope.dart';

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
        Text('$progress%'),
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
            Text('${now.hour}:${now.minute}'),
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
