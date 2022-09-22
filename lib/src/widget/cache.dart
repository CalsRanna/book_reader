import 'package:flutter/material.dart';

import 'scope.dart';

class BookPageOverlayCache extends StatelessWidget {
  const BookPageOverlayCache({super.key});

  @override
  Widget build(BuildContext context) {
    final index = BookReaderScope.of(context)!.index;
    final total = BookReaderScope.of(context)!.total;
    final amount = total - index;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, 50),
              child: const Text('后面50章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, 100),
              child: const Text('后面100章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, amount),
              child: const Text('后面全部'),
            ),
          )
        ],
      ),
    );
  }

  void handleCached(BuildContext context, int amount) {
    BookReaderScope.of(context)!.onCached?.call(amount);
  }
}
