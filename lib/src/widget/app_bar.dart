import 'package:flutter/material.dart';

import 'scope.dart';

class BookPageOverlayAppBar extends StatelessWidget {
  const BookPageOverlayAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BookReaderScope.of(context)!.controller;
    final animation = Tween(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(controller..forward());
    return SlideTransition(
      position: animation,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Row(
              children: [
                IconButton(
                  onPressed: BookReaderScope.of(context)?.onPop,
                  icon: const Icon(Icons.chevron_left_outlined),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: BookReaderScope.of(context)?.onRefresh,
                  child: Row(
                    children: const [Icon(Icons.refresh_outlined), Text('刷新')],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
