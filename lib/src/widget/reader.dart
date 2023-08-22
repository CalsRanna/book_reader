import 'dart:math';

import 'package:book_reader/book_reader.dart';
import 'package:book_reader/src/tool/paginator.dart';
import 'package:book_reader/src/widget/overlay.dart';
import 'package:book_reader/src/widget/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [BookReader] is a widget used to read book. It provide some way to
/// paginate and can be customized by you own choice since we provide
/// many params to do that.
class BookReader extends StatefulWidget {
  const BookReader({
    super.key,
    this.author,
    this.cover,
    this.cursor,
    this.darkMode = false,
    this.duration,
    required this.future,
    this.index,
    required this.name,
    this.theme,
    this.title,
    this.total,
    this.onBookPressed,
    this.onCached,
    this.onCatalogueNavigated,
    this.onChapterChanged,
    this.onPop,
    this.onSettingNavigated,
    this.onMessage,
    this.onRefresh,
    this.onProgressChanged,
    this.onDarkModePressed,
  });

  /// Author of book, can be null if you weren't sure about it.
  final String? author;

  final Image? cover;

  /// The value of [cursor] is the index of pages paginated with style
  /// given. If it is null then the default value is 0.
  final int? cursor;

  final bool darkMode;

  /// Duration for animation, include app and bottom bar slide transition,
  /// and page transition automated.
  final Duration? duration;

  /// Used to fetch content from internet or some other way.**[NOTICE]**
  /// This function can not use ***[setState]*** in it because this
  /// should be called in [build] function.
  final Future<String> Function(int) future;

  /// Current index of chapters.
  final int? index;

  /// Name of book, used to displayed in header and detail modal.
  final String name;

  final ReaderTheme? theme;

  /// Title of chapter, used to displayed in header while is not first page.
  final String? title;

  /// Amount of chapters, if [total] is null then the default value **[1]**
  /// would be used.
  final int? total;

  /// If [onBookPressed] is null, then the button of detail should not be
  /// available. And this function is used to navigate to a new page to
  /// show detail of book and something else you wanna display.
  final void Function()? onBookPressed;

  /// This is used to cache data from internet or some other way, and the
  /// param is the amount of chapters should be cached.
  final void Function(int amount)? onCached;

  /// If this function is null then the button of catalogue should not be
  /// available. And this is used to navigate to the new page to display
  /// custom catalogue page.
  final void Function()? onCatalogueNavigated;

  /// This function will be called when change chapter. And use [future] to
  /// fetch data instead of here.
  final void Function(int index)? onChapterChanged;

  /// When exit the reader page, use this to do something you ever want to.
  /// The first param should be the current [index] of chapters and the
  /// second param should be the [cursor] of pages.
  final void Function(int index, int cursor)? onPop;

  /// This is used to navigate to the new page to display settings.
  final void Function()? onSettingNavigated;

  final void Function()? onDarkModePressed;

  final void Function(String)? onMessage;
  final Future<String> Function(int)? onRefresh;
  final void Function(int)? onProgressChanged;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late int cursor;
  late Duration duration;
  bool hasError = false;
  late int index;
  bool isLoading = true;
  List<String> pages = [];
  late double progress;
  bool showCache = false;
  bool showOverlay = false;
  late ReaderTheme theme;
  late int total;

  @override
  void initState() {
    super.initState();
    cursor = widget.cursor ?? 0;
    duration = widget.duration ?? const Duration(milliseconds: 200);
    index = widget.index ?? 0;
    progress = 0;
    theme = widget.theme ?? ReaderTheme();
    total = widget.total ?? 1;
    controller = AnimationController(duration: duration, vsync: this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void didChangeDependencies() {
    fetchContent();
    calculateProgress();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant BookReader oldWidget) {
    theme = widget.theme ?? ReaderTheme();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: theme.backgroundColor),
          BookPage(
            cursor: min(cursor, pages.length - 1),
            loading: isLoading,
            name: widget.name,
            pages: pages,
            progress: progress,
            theme: theme,
            title: widget.title ?? widget.name,
            onOverlayInserted: handleOverlayInserted,
            onPageDown: handlePageDown,
            onPageUp: handlePageUp,
          ),
          if (showOverlay)
            BookOverlay(
              darkMode: widget.darkMode,
              progress: progress,
              showCache: false,
              onCatalogueNavigated: handleCatalogueNavigated,
              onChapterDown: handleChapterDown,
              onChapterUp: handleChapterUp,
              onOverlayRemoved: handleOverlayRemoved,
              onPop: handlePop,
              onProgressChanged: handleSliderChanged,
              onProgressChangedEnd: handleSliderChangeEnd,
              onRefresh: handleRefresh,
              onDarkModePressed: widget.onDarkModePressed,
            )
        ],
      ),
    );
  }

  Future<void> fetchContent() async {
    setState(() {
      isLoading = true;
    });
    final mediaQuery = MediaQuery.of(context);
    final globalSize = mediaQuery.size;
    final height = globalSize.height -
        theme.headerPadding.vertical -
        theme.headerStyle.fontSize! * theme.headerStyle.height! -
        theme.pagePadding.vertical -
        theme.footerPadding.vertical -
        theme.footerStyle.fontSize! * theme.footerStyle.height!;
    final width = globalSize.width - theme.pagePadding.horizontal;
    var content = await widget.future(index);
    setState(() {
      pages = Paginator(
        size: Size(width, height),
        style: theme.pageStyle,
      ).paginate(content);
      isLoading = false;
    });
  }

  void calculateProgress() {
    setState(() {
      progress = (index + 1) / total;
    });
  }

  /// This function is used to show SystemUiOverlay when slide to return
  /// previous page.
  Future<bool> handleWillPop() {
    setState(() {
      showOverlay = true;
    });
    widget.onPop?.call(index, cursor);
    return Future.value(true);
  }

  void handlePageDown() async {
    final length = pages.length;
    if (cursor + 1 < length) {
      setState(() {
        cursor = cursor + 1;
      });
    } else if (cursor + 1 >= length && index + 1 < total) {
      setState(() {
        cursor = 0;
        index = index + 1;
      });
      widget.onChapterChanged?.call(index);
      await fetchContent();
      calculateProgress();
    } else {
      widget.onMessage?.call('已经是最后一页');
    }
    widget.onProgressChanged?.call(cursor);
  }

  void handlePageUp() async {
    if (cursor > 0) {
      setState(() {
        cursor = cursor - 1;
      });
    } else if (cursor == 0 && index > 0) {
      setState(() {
        index = index - 1;
      });
      widget.onChapterChanged?.call(index);
      await fetchContent();
      calculateProgress();
      final length = pages.length;
      setState(() {
        cursor = length - 1;
      });
    } else {
      widget.onMessage?.call('已经是第一页');
    }
    widget.onProgressChanged?.call(cursor);
  }

  void handleChapterDown() {
    if (index < total - 1) {
      setState(() {
        cursor = 0;
        index = index + 1;
      });
      fetchContent();
      calculateProgress();
      widget.onChapterChanged?.call(index);
    } else {
      widget.onMessage?.call('已经是最后一章');
    }
    widget.onProgressChanged?.call(cursor);
  }

  void handleChapterUp() {
    if (index > 0) {
      setState(() {
        cursor = 0;
        index = index - 1;
      });
      fetchContent();
      calculateProgress();
      widget.onChapterChanged?.call(index);
    } else {
      widget.onMessage?.call('已经是第一章');
    }
    widget.onProgressChanged?.call(cursor);
  }

  void handleOverlayInserted() {
    setState(() {
      showOverlay = true;
    });
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  void handleOverlayRemoved() {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void handleSliderChanged(double value) {
    setState(() {
      progress = value;
    });
  }

  void handleSliderChangeEnd(double value) {
    setState(() {
      cursor = 0;
    });
    var current = (value * total).toInt();
    if (current <= 0) {
      setState(() {
        index = 0;
      });
    } else if (current >= total) {
      setState(() {
        index = total - 1;
      });
    } else {
      setState(() {
        index = current;
      });
    }
    fetchContent();
    calculateProgress();
    widget.onChapterChanged?.call(index);
    widget.onProgressChanged?.call(cursor);
  }

  void handlePop() {
    Navigator.of(context).pop();
    widget.onPop?.call(index, cursor);
  }

  void handleCacheNavigated() {
    setState(() {
      showCache = true;
    });
  }

  void handleCatalogueNavigated() {
    widget.onCatalogueNavigated?.call();
  }

  void handleCached(int amount) {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
    widget.onCached?.call(amount);
    widget.onMessage?.call('缓存开始');
  }

  void handleRefresh() async {
    if (widget.onRefresh != null) {
      setState(() {
        showCache = false;
        showOverlay = false;
        isLoading = true;
      });
      final mediaQuery = MediaQuery.of(context);
      final globalSize = mediaQuery.size;
      final height = globalSize.height -
          theme.headerPadding.vertical -
          theme.headerStyle.fontSize! * theme.headerStyle.height! -
          theme.pagePadding.vertical -
          theme.footerPadding.vertical -
          theme.footerStyle.fontSize! * theme.footerStyle.height!;
      final width = globalSize.width - theme.pagePadding.horizontal;
      var content = await widget.onRefresh!.call(index);
      setState(() {
        pages = Paginator(
          size: Size(width, height),
          style: theme.pageStyle,
        ).paginate(content);
        isLoading = false;
      });
      calculateProgress();
      setState(() {
        cursor = 0;
      });
    }
  }
}
