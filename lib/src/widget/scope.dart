import 'package:flutter/material.dart';

class BookReaderScope extends InheritedWidget {
  const BookReaderScope({
    super.key,
    required this.backgroundColor,
    required this.cursor,
    required this.duration,
    required this.index,
    required this.isDarkMode,
    required this.isLoading,
    required this.name,
    required this.pages,
    required this.progress,
    this.title,
    required this.total,
    required this.textColor,
    required this.withExtraButtons,
    required super.child,
    this.onCacheNavigated,
    this.onCatalogueNavigated,
    this.onChapterDown,
    this.onChapterUp,
    this.onCommentNavigated,
    this.onListenNavigated,
    this.onDarkModeChanged,
    this.onPop,
    this.onRefresh,
    this.onSettingNavigated,
    this.onSliderChanged,
    this.onSliderChangeEnd,
    this.onSourceNavigated,
  });

  final Color backgroundColor;
  final int cursor;
  final Duration duration;
  final int index;
  final bool isDarkMode;
  final bool isLoading;
  final String name;
  final List<String> pages;
  final double progress;
  final String? title;
  final int total;
  final Color textColor;
  final bool withExtraButtons;
  final void Function()? onCacheNavigated;
  final void Function()? onCatalogueNavigated;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function()? onCommentNavigated;
  final void Function()? onListenNavigated;
  final void Function()? onDarkModeChanged;
  final void Function()? onPop;
  final void Function()? onRefresh;
  final void Function()? onSettingNavigated;
  final void Function(double)? onSliderChanged;
  final void Function(double)? onSliderChangeEnd;
  final void Function()? onSourceNavigated;

  @override
  bool updateShouldNotify(BookReaderScope oldWidget) {
    return backgroundColor != oldWidget.backgroundColor ||
        cursor != oldWidget.cursor ||
        duration != oldWidget.duration ||
        index != oldWidget.index ||
        name != oldWidget.name ||
        pages != oldWidget.pages ||
        progress != oldWidget.progress ||
        title != oldWidget.title ||
        total != oldWidget.total;
  }

  static BookReaderScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BookReaderScope>();
  }
}