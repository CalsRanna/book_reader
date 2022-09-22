import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'bottom_bar.dart';
import 'scope.dart';

class BookPageOverlay extends StatefulWidget {
  const BookPageOverlay({super.key});

  @override
  State<BookPageOverlay> createState() => _BookPageOverlayState();
}

class _BookPageOverlayState extends State<BookPageOverlay> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const BookPageOverlayAppBar(),
          Expanded(
            child: GestureDetector(
              onTap: handleTap,
              child: Container(color: Colors.transparent),
            ),
          ),
          const BookPageOverlayBottomBar(),
        ],
      ),
    );
  }

  void showModal() {
    setState(() {
      visible = !visible;
    });
  }

  void handleTap() {
    if (visible) {
      setState(() {
        visible = false;
      });
    } else {
      BookReaderScope.of(context)!.onOverlayRemoved?.call();
    }
  }
}
