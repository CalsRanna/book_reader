import 'package:book_reader/src/widget/footer.dart';
import 'package:book_reader/src/widget/header.dart';
import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({
    super.key,
    this.backgroundColor,
    required this.content,
    required this.header,
    required this.current,
    required this.total,
    this.onOverlayOpened,
    this.onPageDown,
    this.onPageUp,
  });

  final Color? backgroundColor;
  final String content;
  final int current;
  final String header;
  final int total;
  final void Function()? onOverlayOpened;
  final void Function(int page, int total)? onPageDown;
  final void Function(int page)? onPageUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: backgroundColor ?? Colors.white),
          GestureDetector(
            onTapUp: (details) => handleTap(context, details),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                BookPageHeader(text: header),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Text(content),
                  ),
                ),
                BookPageFooter(current: current, total: total),
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
      onPageUp?.call(current);
    } else if (position.dx > width ~/ 3 * 2) {
      onPageDown?.call(current, total);
    } else {
      onOverlayOpened?.call();
    }
  }
}
