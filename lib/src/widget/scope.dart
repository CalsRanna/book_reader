import 'package:flutter/material.dart';

class BookReaderScope extends InheritedWidget {
  const BookReaderScope({
    super.key,
    required this.backgroundColor,
    required this.cursor,
    required this.duration,
    required this.footerPadding,
    required this.headerPadding,
    required this.pagePadding,
    required this.pageStyle,
    required this.index,
    required this.isDarkMode,
    required this.isLoading,
    required this.name,
    required this.progress,
    required this.textColor,
    this.title,
    required this.total,
    required this.withExtraButtons,
    required super.child,
    this.onCacheNavigated,
    this.onCatalogueNavigated,
    this.onChapterDown,
    this.onChapterUp,
    this.onCommentNavigated,
    this.onListenNavigated,
    this.onDarkModeChanged,
    this.onOverlayInserted,
    this.onOverlayRemoved,
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
  final EdgeInsets footerPadding;
  final EdgeInsets headerPadding;
  final EdgeInsets pagePadding;
  final TextStyle pageStyle;
  final int index;
  final bool isDarkMode;
  final bool isLoading;
  final String name;
  final double progress;
  final Color textColor;
  final String? title;
  final int total;
  final bool withExtraButtons;
  final void Function()? onCacheNavigated;
  final void Function()? onCatalogueNavigated;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function()? onCommentNavigated;
  final void Function()? onListenNavigated;
  final void Function()? onDarkModeChanged;
  final void Function()? onOverlayInserted;
  final void Function()? onOverlayRemoved;
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
        footerPadding != oldWidget.footerPadding ||
        headerPadding != oldWidget.headerPadding ||
        pagePadding != oldWidget.pagePadding ||
        index != oldWidget.index ||
        name != oldWidget.name ||
        progress != oldWidget.progress ||
        textColor != oldWidget.textColor ||
        title != oldWidget.title ||
        total != oldWidget.total ||
        withExtraButtons != oldWidget.withExtraButtons;
  }

  static BookReaderScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BookReaderScope>();
  }
}
