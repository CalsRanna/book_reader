import 'package:book_reader/src/widget/scope.dart';
import 'package:flutter/material.dart';

class BookReaderOverlayMask extends StatefulWidget {
  const BookReaderOverlayMask({super.key});

  @override
  State<BookReaderOverlayMask> createState() => _BookReaderOverlayMaskState();
}

class _BookReaderOverlayMaskState extends State<BookReaderOverlayMask> {
  @override
  Widget build(BuildContext context) {
    final controller = BookReaderScope.of(context)!.controller;
    final animation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(controller);
    return Expanded(
      child: SlideTransition(
        position: animation,
        child: GestureDetector(
          onTap: handleTap,
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  void handleTap() {
    print('mask tap');
    BookReaderScope.of(context)?.controller.reverse();
  }
}
