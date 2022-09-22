import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tool/message.dart';
import '../tool/paginator.dart';
import 'loading.dart';
import 'overlay.dart';
import 'page.dart';
import 'scope.dart';

/// [BookReader] is a widget used to read book. It provide some way to
/// paginate and can be customered by you own choice since we provide
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
  /// and page transtion automated.
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
  /// availabled. And this function is used to navigate to a new page to
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

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> with TickerProviderStateMixin {
  late Color backgroundColor;
  late AnimationController controller;
  late int cursor;
  late Duration duration;
  bool hasError = false;
  late EdgeInsets footerPadding;
  late EdgeInsets headerPadding;
  late int index;
  bool isDarkMode = false;
  bool isLoading = true;
  late EdgeInsets pagePadding;
  late List<String> pages;
  late TextStyle pageStyle;
  late double progress;
  bool showCache = false;
  bool showOverlay = false;
  bool showSetting = false;
  late Size size;
  late Color textColor;
  late int total;
  late bool withExtraButtons;

  @override
  void initState() {
    backgroundColor = widget.backgroundColor ?? Colors.white;
    cursor = widget.cursor ?? 0;
    duration = widget.duration ?? const Duration(milliseconds: 200);
    footerPadding = const EdgeInsets.only(
      bottom: 24,
      left: 16,
      right: 16,
      top: 8,
    );
    headerPadding = const EdgeInsets.only(
      bottom: 8,
      left: 16,
      right: 16,
      top: 67,
    );
    index = widget.index ?? 0;
    pagePadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    pages = [];
    progress = 0;
    total = widget.total ?? 1;
    textColor = Colors.black;
    withExtraButtons = widget.withExtraButtons ?? true;

    controller = AnimationController(duration: duration, vsync: this);
    pageStyle = TextStyle(color: textColor, fontSize: 18);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    calculateAvailableSize();
    fetchContent();
    calculateProgress();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void calculateAvailableSize() {
    final globalSize = MediaQuery.of(context).size;
    final height = globalSize.height -
        headerPadding.vertical -
        10 -
        pagePadding.vertical -
        footerPadding.vertical -
        10;
    final width = globalSize.width - pagePadding.horizontal;
    setState(() {
      size = Size(width, height);
    });
  }

  void fetchContent() async {
    setState(() {
      isLoading = true;
    });
    var content = await widget.future(index);
    setState(() {
      pages = Paginator(size: size, style: pageStyle).paginate(content);
      isLoading = false;
    });
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
      backgroundColor: Colors.transparent,
      body: BookReaderScope(
        backgroundColor: backgroundColor,
        controller: controller,
        cursor: cursor,
        duration: duration,
        footerPadding: footerPadding,
        headerPadding: headerPadding,
        index: index,
        isDarkMode: isDarkMode,
        isLoading: isLoading,
        name: widget.name,
        pagePadding: pagePadding,
        pages: pages,
        pageStyle: pageStyle,
        progress: progress,
        showCache: showCache,
        showSetting: showSetting,
        textColor: textColor,
        title: widget.title,
        total: total,
        withExtraButtons: withExtraButtons,
        onCached: handleCached,
        onCacheNavigated: handleCacheNavigated,
        onCatalogueNavigated: widget.onCatalogueNavigated,
        onChapterDown: handleChapterDown,
        onChapterUp: handleChapterUp,
        onDarkModeChanged: handleDarkModeChanged,
        onOverlayInserted: handleOverlayInserted,
        onOverlayRemoved: handleOverlayRemoved,
        onPageDown: handlePageDown,
        onPageUp: handlePageUp,
        onPop: handlePop,
        onRefresh: handleRefresh,
        onSetting: widget.onSettingNavigated,
        onSettingNavigated: handleSettingNavigated,
        onSliderChanged: handleSliderChanged,
        onSliderChangeEnd: handleSliderChangeEnd,
        child: Stack(
          children: [
            Container(color: backgroundColor),
            Builder(builder: (context) {
              if (isLoading) {
                return const BookLoading();
              } else {
                if (hasError) {
                  return const Text('Error');
                } else {
                  return WillPopScope(
                    onWillPop: handleWillPop,
                    child: Stack(
                      children: [
                        const BookPage(),
                        if (showOverlay) const BookPageOverlay()
                      ],
                    ),
                  );
                }
              }
            }),
          ],
        ),
      ),
    );
  }

  /// This function is used to show SystemUiOverlay when slide to return
  /// previous page.
  Future<bool> handleWillPop() {
    setState(() {
      showOverlay = true;
    });
    return Future.value(true);
  }

  void handlePageDown() {
    final length = pages.length;
    if (cursor + 1 < length) {
      setState(() {
        cursor = cursor + 1;
      });
    } else if (cursor + 1 == length && index < total - 1) {
      setState(() {
        cursor = 0;
        index = index + 1;
      });
      fetchContent();
      calculateProgress();
      widget.onChapterChanged?.call(index);
    } else {
      Message.show(context, duration: duration, message: '已经是最后一页');
    }
  }

  void handlePageUp() {
    final length = pages.length;
    if (cursor > 0) {
      setState(() {
        cursor = cursor - 1;
      });
    } else if (cursor == 0 && index > 0) {
      setState(() {
        index = index - 1;
      });
      fetchContent();
      calculateProgress();
      setState(() {
        cursor = length - 1;
      });
      widget.onChapterChanged?.call(index);
    } else {
      Message.show(context, duration: duration, message: '已经是第一页');
    }
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
      Message.show(context, duration: duration, message: '已经是最后一章');
    }
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
      Message.show(context, duration: duration, message: '已经是第一章');
    }
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
      showOverlay = true;
    });
  }

  void handleOverlayRemoved() {
    setState(() {
      showCache = false;
      showOverlay = false;
      showSetting = false;
    });
  }

  void handleSliderChanged(double value) {
    setState(() {
      progress = value;
    });
  }

  void handleSliderChangeEnd(double value) {
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

  void handleCached(int amount) {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
    widget.onCached?.call(amount);
    Message.show(context, duration: duration, message: '缓存开始');
  }

  void handleRefresh() {
    setState(() {
      showCache = false;
      showOverlay = false;
    });
    fetchContent();
    calculateProgress();
    setState(() {
      cursor = 0;
    });
  }

  void handleSettingNavigated() {
    setState(() {
      showSetting = true;
    });
  }
}
