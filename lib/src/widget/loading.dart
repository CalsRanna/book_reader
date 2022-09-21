import 'package:flutter/material.dart';

import 'scope.dart';

class BookLoading extends StatelessWidget {
  const BookLoading({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: BookReaderScope.of(context)!.textColor,
      fontSize: 10,
      height: 1,
    );
    final now = DateTime.now();

    return Scaffold(
      body: DefaultTextStyle.merge(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(name),
            ),
            const Expanded(
              child: Center(child: CircularProgressIndicator.adaptive()),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('获取中'),
                  const Expanded(child: SizedBox()),
                  Text('${now.hour}:${now.minute}'),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void handleTap(BuildContext context, TapUpDetails details) {}
}
