import 'dart:math';

import 'package:flutter/material.dart';

class BookPageFooter extends StatelessWidget {
  const BookPageFooter({
    super.key,
    this.current = 1,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.progress = 0,
    this.style = const TextStyle(color: Colors.black, fontSize: 10, height: 1),
    this.total = 0,
  });

  final int current;
  final EdgeInsets padding;
  final double progress;
  final TextStyle style;
  final int total;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
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
