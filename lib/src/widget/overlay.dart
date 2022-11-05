import 'package:book_reader/src/widget/mask.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'bottom_bar.dart';
import 'cache.dart';
import 'scope.dart';
import 'setting.dart';

class BookPageOverlay extends StatefulWidget {
  const BookPageOverlay({super.key});

  @override
  State<BookPageOverlay> createState() => _BookPageOverlayState();
}

class _BookPageOverlayState extends State<BookPageOverlay> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final showCache = BookReaderScope.of(context)!.showCache;
    final showSetting = BookReaderScope.of(context)!.showSetting;

    return GestureDetector(
      onTap: () {
        BookReaderScope.of(context)?.controller.forward();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const BookPageOverlayAppBar(),
            const BookReaderOverlayMask(),
            if (showCache) const BookPageOverlayCache(),
            if (showSetting) const BookPageOverlaySetting(),
            if (!showCache && !showSetting) const BookPageOverlayBottomBar(),
          ],
        ),
      ),
    );
  }

  void showModal() {
    setState(() {
      visible = !visible;
    });
  }

  void handleTap() {
    final controller = BookReaderScope.of(context)?.controller.reverse();
    // if (visible) {
    //   setState(() {
    //     visible = false;
    //   });
    // } else {
    //   BookReaderScope.of(context)!.onOverlayRemoved?.call();
    // }
  }
}
