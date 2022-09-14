import 'package:flutter/material.dart';

class BookReaderQuery extends InheritedWidget {
  const BookReaderQuery({
    super.key,
    required this.cursor,
    required this.duration,
    required this.index,
    required this.progress,
    required this.total,
    required this.withExtraButtons,
    required super.child,
    this.onCatalogueNavigated,
    this.onCommentNavigated,
    this.onRefresh,
    this.onSourceNavigated,
  });

  final int cursor;
  final Duration duration;
  final int index;
  final double progress;
  final int total;
  final bool withExtraButtons;
  final void Function()? onCatalogueNavigated;
  final void Function()? onCommentNavigated;
  final void Function()? onRefresh;
  final void Function()? onSourceNavigated;

  @override
  bool updateShouldNotify(BookReaderQuery oldWidget) {
    return index != oldWidget.index ||
        cursor != oldWidget.cursor ||
        duration != oldWidget.duration ||
        progress != oldWidget.progress ||
        total != oldWidget.total;
  }

  static BookReaderQuery? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BookReaderQuery>();
  }
}
