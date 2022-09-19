import 'package:book_reader/src/widget/footer.dart';
import 'package:book_reader/src/widget/header.dart';
import 'package:book_reader/src/widget/scope.dart';
import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({
    super.key,
    required this.content,
    this.onOverlayOpened,
    this.onPageDown,
    this.onPageUp,
  });

  final String content;
  final void Function()? onOverlayOpened;
  final void Function()? onPageDown;
  final void Function()? onPageUp;

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
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      content,
                      style: TextStyle(
                        color: BookReaderScope.of(context)!.textColor,
                      ),
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

  void handleTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final position = details.globalPosition;
    if (position.dx < width ~/ 3) {
      onPageUp?.call();
    } else if (position.dx > width ~/ 3 * 2) {
      onPageDown?.call();
    } else {
      onOverlayOpened?.call();
    }
  }
}
