import 'package:book_reader/src/tool/paginator.dart';
import 'package:book_reader/src/widget/loading.dart';
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
    this.backgroundColor,
    this.cover,
    this.cursor,
    this.duration,
    required this.future,
    this.index,
    required this.name,
    this.title,
    this.total,
    this.withExtraButtons,
    this.onBookPressed,
    this.onCached,
    this.onCatalogueNavigated,
    this.onChapterChanged,
    this.onPop,
    this.onSettingNavigated,
    this.onMessage,
    this.onRefresh,
    this.onProgressChanged,
  });

  /// Author of book, can be null if you weren't sure about it.
  final String? author;

  /// If [backgroundColor] is null, the default value is [Colors.white].
  final Color? backgroundColor;
  final Image? cover;

  /// The value of [cursor] is the index of pages paginated with style
  /// given. If it is null then the default value is 0.
  final int? cursor;

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

  /// Title of chapter, used to displayed in header while is not first page.
  final String? title;

  /// Amount of chapters, if [total] is null then the default value **[1]**
  /// would be used.
  final int? total;

  /// Determine whether show extra buttons or not. If it was null, the
  /// default value is true.
  final bool? withExtraButtons;

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

  final void Function(String)? onMessage;
  final Future<String> Function(int)? onRefresh;
  final void Function(int)? onProgressChanged;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader>
    with SingleTickerProviderStateMixin {
  late Color backgroundColor;
  late AnimationController controller;
  late int cursor;
  late Duration duration;
  bool hasError = false;
  EdgeInsets footerPadding = const EdgeInsets.only(
    bottom: 24,
    left: 16,
    right: 16,
    top: 8,
  );
  late EdgeInsets headerPadding = const EdgeInsets.only(
    bottom: 8,
    left: 16,
    right: 16,
    top: 67,
  );
  late int index;
  bool isDarkMode = false;
  bool isLoading = true;
  EdgeInsets pagePadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  List<String> pages = [];
  TextStyle pageStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 26 / 18,
    letterSpacing: 0,
  );
  TextStyle headerStyle = const TextStyle(fontSize: 10, height: 1);
  TextStyle footerStyle = const TextStyle(fontSize: 10, height: 1);
  late double progress;
  bool showCache = false;
  bool showOverlay = false;
  late Color textColor;
  late int total;
  late bool withExtraButtons;

  @override
  void initState() {
    backgroundColor = widget.backgroundColor ?? Colors.white;
    cursor = widget.cursor ?? 0;
    duration = widget.duration ?? const Duration(milliseconds: 200);
    index = widget.index ?? 0;
    progress = 0;
    total = widget.total ?? 1;
    withExtraButtons = widget.withExtraButtons ?? true;

    controller = AnimationController(duration: duration, vsync: this);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    fetchContent();
    calculateProgress();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void calculateProgress() {
    setState(() {
      progress = (index + 1) / total;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: showOverlay ? SystemUiOverlay.values : [],
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Colors.white),
          if (isLoading) BookLoading(onTap: handleOverlayInserted),
          // const Text('Error'),
          if (!isLoading)
            BookPage(
              cursor: cursor,
              pages: pages,
              padding: pagePadding,
              headerPadding: headerPadding,
              name: widget.name,
              title: widget.title ?? widget.name,
              footerPadding: footerPadding,
              progress: progress,
              onOverlayInserted: handleOverlayInserted,
              onPageDown: handlePageDown,
              onPageUp: handlePageUp,
              footerStyle: footerStyle,
              headerStyle: headerStyle,
              style: pageStyle,
            ),
          if (showOverlay)
            BookOverlay(
              showCache: false,
              onOverlayRemoved: handleOverlayInserted,
              onPop: handlePop,
              onRefresh: handleRefresh,
              onChapterDown: handleChapterDown,
              onChapterUp: handleChapterUp,
              progress: progress,
              onProgressChanged: handleSliderChanged,
              onProgressChangedEnd: handleSliderChangeEnd,
              onCatalogueNavigated: handleCatalogueNavigated,
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
        headerPadding.vertical -
        headerStyle.fontSize! * headerStyle.height! -
        pagePadding.vertical -
        footerPadding.vertical -
        footerStyle.fontSize! * footerStyle.height!;
    final width = globalSize.width - pagePadding.horizontal;
    var content = await widget.future(index);
    content = content.replaceAll('\n', '\n\n');
    setState(() {
      pages = Paginator(
        size: Size(width, height),
        style: pageStyle,
      ).paginate(content);
      isLoading = false;
    });
  }

  /// This function is used to show SystemUiOverlay when slide to return
  /// previous page.
  Future<bool> handleWillPop() {
    setState(() {
      showOverlay = true;
    });
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

  void handleDarkModeChanged() {
    setState(() {
      isDarkMode = !isDarkMode;
      backgroundColor = isDarkMode ? Colors.black : Colors.white;
      textColor = isDarkMode ? Colors.white : Colors.black;
      pageStyle = TextStyle(color: textColor, fontSize: 18);
    });
  }

  void handleOverlayInserted() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }

  void handleOverlayRemoved() {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
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
          headerPadding.vertical -
          headerStyle.fontSize! * headerStyle.height! -
          pagePadding.vertical -
          footerPadding.vertical -
          footerStyle.fontSize! * footerStyle.height!;
      final width = globalSize.width - pagePadding.horizontal;
      var content = await widget.onRefresh!.call(index);
      content = content.replaceAll('\n', '\n\n');
      setState(() {
        pages = Paginator(
          size: Size(width, height),
          style: pageStyle,
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
