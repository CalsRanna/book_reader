import 'package:flutter/material.dart';

import 'footer.dart';
import 'header.dart';
import 'scope.dart';

class BookLoading extends StatelessWidget {
  const BookLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: BookReaderScope.of(context)!.backgroundColor),
          GestureDetector(
            onTapUp: (details) => handleTap(context, details),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                const BookPageHeader(),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
                const BookPageFooter(),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          )
        ],
      ),
    );
  }

  void handleTap(BuildContext context, TapUpDetails details) {}
}
