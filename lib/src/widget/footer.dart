import 'dart:math';

import 'package:flutter/material.dart';

import 'scope.dart';

class BookPageFooter extends StatelessWidget {
  const BookPageFooter({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final current = BookReaderScope.of(context)!.cursor + 1;
    final total = BookReaderScope.of(context)!.pages.length;
    final progress = BookReaderScope.of(context)!.progress * 100;
    final now = DateTime.now();
    final style = TextStyle(
      color: BookReaderScope.of(context)!.textColor,
      fontSize: 10,
      height: 1,
    );
    return Container(
      padding: padding,
      child: DefaultTextStyle.merge(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
        child: Row(
          children: [
            Text('$current/$total'),
            const SizedBox(width: 16),
            Text('$progress%'),
            const Expanded(child: SizedBox()),
            Text('${now.hour}:${now.minute}'),
            Transform.rotate(
              angle: pi / 2,
              child: const Icon(Icons.battery_5_bar_outlined, size: 12),
            ),
          ],
        ),
      ),
    );
  }
}
