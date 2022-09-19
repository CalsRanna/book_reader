import 'package:book_reader/src/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tool/paginator.dart';
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
    this.onCatalogueNavigated,
    this.onChapterChanged,
    this.onPop,
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

  /// If this function is null then the button of catalogue should not be
  /// available. And this is used to navigate to the new page to display
  /// custom catalogue page.
  final void Function()? onCatalogueNavigated;

  /// When chapter changed or first inited, use this function to fetch
  /// data and do some thing you need. The param should be the current
  /// [index] of chapters.
  final void Function(int index)? onChapterChanged;

  /// When exit the reader page, use this to do something you ever want to.
  /// The first param should be the current [index] of chapters and the
  /// second param should be the [cursor] of pages.
  final void Function(int index, int cursor)? onPop;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late Color backgroundColor;
  late String content;
  late PageController controller;
  late int cursor;
  late Duration duration;
  late int index;
  bool isDarkMode = false;
  bool isLoading = true;
  EdgeInsets padding = const EdgeInsets.all(16);
  late double progress;
  bool showOverlay = false;
  late Size size;
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
    textColor = Colors.black;
    withExtraButtons = widget.withExtraButtons ?? true;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    calculateAvailableSize();
    fetchContent();
    calculateProgress();
    super.didChangeDependencies();
  }

  void calculateAvailableSize() {
    final globalSize = MediaQuery.of(context).size;
    final globalPadding = MediaQuery.of(context).padding;
    const headerHeight = 26;
    const footerHeight = 26;
    final width = globalSize.width - padding.horizontal;
    final height = globalSize.height -
        // globalPadding.vertical -
        (globalPadding.top + 8) -
        padding.vertical -
        headerHeight -
        footerHeight;
    setState(() {
      size = Size(width, height);
    });
  }

  Future fetchContent() async {
    var content = await widget.future(index);
    return Paginator(size: size).paginate(content);
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
      overlays: showOverlay ? [SystemUiOverlay.top] : [],
    );

    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pages = snapshot.data as List<String>;
            return BookReaderScope(
              backgroundColor: backgroundColor,
              cursor: cursor,
              duration: duration,
              index: index,
              isDarkMode: isDarkMode,
              isLoading: isLoading,
              name: widget.name,
              pages: pages,
              progress: progress,
              textColor: textColor,
              title: widget.title,
              total: total,
              withExtraButtons: withExtraButtons,
              onCatalogueNavigated: widget.onCatalogueNavigated,
              onChapterDown: handleChapterDown,
              onChapterUp: handleChapterUp,
              onDarkModeChanged: handleDarkModeChanged,
              onSliderChanged: handleSliderChanged,
              onSliderChangeEnd: handleSliderChangeEnd,
              child: WillPopScope(
                onWillPop: handleWillPop,
                child: Stack(
                  children: [
                    BookPage(
                      content: pages.isNotEmpty ? pages[cursor] : '暂无内容',
                      onPageDown: () => handlePageDown(pages.length),
                      onPageUp: () => handlePageUp(pages.length),
                      onOverlayOpened: handleTap,
                    ),
                    if (showOverlay)
                      BookPageOverlay(
                        author: widget.author ?? '',
                        cover: Image.network(''),
                        duration: duration,
                        name: widget.name,
                        onPop: handlePop,
                        onOverlayClosed: handleTap,
                      )
                  ],
                ),
              ),
            );
          } else {
            var pages = <String>[];

            return BookReaderScope(
              backgroundColor: backgroundColor,
              cursor: cursor,
              duration: duration,
              index: index,
              isDarkMode: isDarkMode,
              isLoading: isLoading,
              name: widget.name,
              pages: pages,
              progress: progress,
              textColor: textColor,
              title: widget.title,
              total: total,
              withExtraButtons: withExtraButtons,
              onCatalogueNavigated: widget.onCatalogueNavigated,
              onChapterDown: handleChapterDown,
              onChapterUp: handleChapterUp,
              onDarkModeChanged: handleDarkModeChanged,
              onSliderChanged: handleSliderChanged,
              onSliderChangeEnd: handleSliderChangeEnd,
              child: WillPopScope(
                onWillPop: handleWillPop,
                child: Stack(
                  children: [
                    const BookLoading(),
                    if (showOverlay)
                      BookPageOverlay(
                        author: widget.author ?? '',
                        cover: Image.network(''),
                        duration: duration,
                        name: widget.name,
                        onPop: handlePop,
                        onOverlayClosed: handleTap,
                      )
                  ],
                ),
              ),
            );
          }
        },
        future: fetchContent(),
      ),
    );
  }

  Future<bool> handleWillPop() {
    setState(() {
      showOverlay = false;
    });
    return Future.value(true);
  }

  void handlePageDown(int length) {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('已经是最后一页'),
        duration: duration,
      ));
    }
  }

  void handlePageUp(int length) {
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('已经是第一页'),
        duration: duration,
      ));
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('已经是最后一章'),
        duration: duration,
      ));
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('已经是第一章'),
        duration: duration,
      ));
    }
  }

  void handleDarkModeChanged() {
    setState(() {
      isDarkMode = !isDarkMode;
      backgroundColor = isDarkMode ? Colors.black : Colors.white;
      textColor = isDarkMode ? Colors.white : Colors.black;
    });
  }

  void handleTap() {
    setState(() {
      showOverlay = !showOverlay;
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
}
