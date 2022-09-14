import 'package:flutter/material.dart';

class BookReaderQuery extends InheritedWidget {
  final int index;
  final List<String>? chapters;
  final int cursor;
  final Duration duration;
  final double progress;

  const BookReaderQuery({
    super.key,
    this.index = 0,
    this.chapters,
    this.cursor = 0,
    this.duration = const Duration(milliseconds: 200),
    this.progress = 0,
    required super.child,
  });

  @override
  bool updateShouldNotify(BookReaderQuery oldWidget) {
    return index != oldWidget.index ||
        chapters != oldWidget.chapters ||
        cursor != oldWidget.cursor ||
        duration != oldWidget.duration ||
        progress != oldWidget.progress;
  }

  static BookReaderQuery? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BookReaderQuery>();
  }
}
