import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:book_reader/book_reader.dart';
import 'package:book_reader/src/tool/paginator.dart';
import 'package:book_reader/src/widget/overlay.dart';
import 'package:book_reader/src/widget/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';

/// [BookReader] is a widget used to read book. It provide some way to
/// paginate and can be customized by you own choice since we provide
/// many params to do that.
class BookReader extends StatefulWidget {
  /// [author], [cover], [name] should not be null.
  /// [future] is used to fetch content from internet or some other way.
  const BookReader({
    super.key,
    required this.author,
    required this.cover,
    this.cursor,
    this.darkMode = false,
    this.duration,
    required this.future,
    this.index,
    this.modes = PageTurningMode.values,
    required this.name,
    this.theme,
    this.title,
    this.total,
    this.onBookPressed,
    this.onCached,
    this.onCataloguePressed,
    this.onChapterChanged,
    this.onDarkModePressed,
    this.onDetailPressed,
    this.onMessage,
    this.onPop,
    this.onProgressChanged,
    this.onRefresh,
    this.onSettingPressed,
    this.onSourcePressed,
  });

  /// Author of book, can be null if you weren't sure about it.
  final String author;

  /// Basically a cover of book, should be an image.
  final Widget cover;

  /// The value of [cursor] is the index of pages paginated with style
  /// given. If it is null then the default value is 0.
  final int? cursor;

  /// Current dark mode of app.
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

  /// Determine how to trigger page change
  final List<PageTurningMode> modes;

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
  final void Function()? onCataloguePressed;

  /// This function will be called when change chapter. And use [future] to
  /// fetch data instead of here.
  final void Function(int index)? onChapterChanged;

  /// When exit the reader page, use this to do something you ever want to.
  /// The first param should be the current [index] of chapters and the
  /// second param should be the [cursor] of pages.
  final void Function(int index, int cursor)? onPop;

  final void Function()? onDarkModePressed;

  final void Function(String)? onMessage;
  final Future<String> Function(int)? onRefresh;
  final void Function(int)? onProgressChanged;

  /// This is used to navigate to the new page to display settings.
  final void Function()? onSettingPressed;

  final void Function()? onSourcePressed;

  final void Function()? onDetailPressed;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late int cursor;
  late Duration duration;
  String? error;
  bool hasError = false;
  late int index;
  bool isLoading = true;
  String? nextError;
  List<String> nextPages = [];
  int oldIndex = 0;
  List<String> pages = [];
  List<String> previousPages = [];
  String? previousError;
  late double progress;
  bool showCache = false;
  bool showOverlay = false;
  late ReaderTheme theme;
  late int total;
  Size size = Size.zero;
  late StreamSubscription<HardwareButton>? subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (theme.backgroundImage.isEmpty)
            Container(color: theme.backgroundColor),
          if (theme.backgroundImage.isNotEmpty)
            Image.asset(
              theme.backgroundImage,
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          BookPage(
            cursor: min(cursor, pages.length - 1),
            error: error,
            loading: isLoading,
            modes: widget.modes,
            name: widget.name,
            pages: pages,
            progress: progress,
            theme: theme,
            title: widget.title ?? widget.name,
            onOverlayInserted: handleOverlayInserted,
            onPageDown: handlePageDown,
            onPageUp: handlePageUp,
            onRefresh: handleRefresh,
          ),
          if (showOverlay)
            BookOverlay(
              author: widget.author,
              cover: widget.cover,
              darkMode: widget.darkMode,
              name: widget.name,
              progress: progress,
              onCache: handleCached,
              onCataloguePressed: handleCataloguePressed,
              onChapterDown: handleChapterDown,
              onChapterUp: handleChapterUp,
              onDarkModePressed: widget.onDarkModePressed,
              onDetailPressed: widget.onDetailPressed,
              onOverlayRemoved: handleOverlayRemoved,
              onPop: handlePop,
              onRefresh: handleRefresh,
              onSettingPressed: widget.onSettingPressed,
              onSliderChanged: handleSliderChanged,
              onSliderChangedEnd: handleSliderChangeEnd,
              onSourcePressed: widget.onSourcePressed,
            )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (size == Size.zero) {
      size = calculateSize();
      fetchContent();
      calculateProgress();
      super.didChangeDependencies();
    }
  }

  @override
  void didUpdateWidget(covariant BookReader oldWidget) {
    theme = widget.theme ?? ReaderTheme();
    if (oldWidget.theme?.pageStyle != theme.pageStyle) {
      fetchContent(force: true);
      calculateProgress();
    }
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
    if (Platform.isAndroid) {
      subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
        if (mounted) {
          if (event == HardwareButton.volume_down) {
            handlePageDown();
          } else if (event == HardwareButton.volume_up) {
            handlePageUp();
          }
        }
      });
    }
  }

  void calculateProgress() {
    setState(() {
      progress = (index + 1) / total;
    });
  }

  Size calculateSize() {
    final mediaQuery = MediaQuery.of(context);
    final globalSize = mediaQuery.size;
    final height = globalSize.height -
        theme.headerPadding.vertical -
        theme.headerStyle.fontSize! * theme.headerStyle.height! -
        theme.pagePadding.vertical -
        theme.footerPadding.vertical -
        theme.footerStyle.fontSize! * theme.footerStyle.height!;
    final width = globalSize.width - theme.pagePadding.horizontal;
    return Size(width, height);
  }

  Future<void> fetchContent({bool force = false}) async {
    if (nextPages.isEmpty || previousPages.isEmpty || oldIndex == 0 || force) {
      fetch(index);
      preload(index);
    } else {
      copy();
      preload(index);
    }
  }

  void fetch(int index) async {
    setState(() {
      isLoading = true;
    });
    try {
      var content = await widget.future(index);
      final paginator = Paginator(size: size, theme: theme);
      final pages = paginator.paginate(content);
      setState(() {
        error = null;
        this.pages = pages;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        this.error = error.toString();
        pages = [];
        isLoading = false;
      });
    }
  }

  void preload(int index) async {
    final paginator = Paginator(size: size, theme: theme);
    if (index - 1 >= 0) {
      try {
        final content = await widget.future(index - 1);
        previousPages = paginator.paginate(content);
        previousError = null;
      } catch (error) {
        previousPages = [];
        previousError = error.toString();
      }
    }
    if (index + 1 < total) {
      try {
        final content = await widget.future(index + 1);
        nextPages = paginator.paginate(content);
        nextError = null;
      } catch (error) {
        nextPages = [];
        nextError = error.toString();
      }
    }
  }

  void copy() {
    if (oldIndex < index) {
      setState(() {
        error = nextError;
        pages = nextPages;
      });
    } else {
      setState(() {
        error = previousError;
        pages = previousPages;
      });
    }
  }

  void handleCached(int amount) {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    widget.onCached?.call(amount);
    widget.onMessage?.call('缓存开始');
  }

  void handleCataloguePressed() {
    widget.onCataloguePressed?.call();
  }

  void handleChapterDown() {
    if (index < total - 1) {
      setState(() {
        cursor = 0;
        oldIndex = index;
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
        oldIndex = index;
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

  void handlePageDown() async {
    final length = pages.length;
    if (cursor + 1 < length) {
      setState(() {
        cursor = cursor + 1;
      });
    } else if (cursor + 1 >= length && index + 1 < total) {
      setState(() {
        cursor = 0;
        oldIndex = index;
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
        oldIndex = index;
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

  void handlePop() {
    widget.onPop?.call(index, cursor);
  }

  void handleRefresh() async {
    if (widget.onRefresh != null) {
      setState(() {
        showCache = false;
        showOverlay = false;
        isLoading = true;
      });
      try {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
        var content = await widget.onRefresh!.call(index);
        final paginator = Paginator(size: size, theme: theme);
        setState(() {
          error = null;
          pages = paginator.paginate(content);
        });
        calculateProgress();
        setState(() {
          cursor = 0;
          isLoading = false;
        });
      } catch (error) {
        setState(() {
          cursor = 0;
          this.error = error.toString();
          pages = [];
          isLoading = false;
        });
      }
    }
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
        oldIndex = 0;
      });
    } else if (current >= total) {
      setState(() {
        index = total - 1;
        oldIndex = 0;
      });
    } else {
      setState(() {
        index = current;
        oldIndex = 0;
      });
    }
    fetchContent();
    calculateProgress();
    widget.onChapterChanged?.call(index);
    widget.onProgressChanged?.call(cursor);
  }
}
