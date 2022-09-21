import 'package:book_reader/src/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tool/message.dart';
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

  /// This function will be called when change chapter. And use [future] to
  /// fetch data instead of here.
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
    progress = 0;
    total = widget.total ?? 1;
    textColor = Colors.black;
    withExtraButtons = widget.withExtraButtons ?? true;

    pageStyle = TextStyle(color: textColor, fontSize: 18);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    hideSystemUiOverlay();
    calculateAvailableSize();
    fetchContent();
    calculateProgress();
    super.didChangeDependencies();
  }

  void calculateAvailableSize() {
    final globalSize = MediaQuery.of(context).size;
    final width = globalSize.width - pagePadding.horizontal;
    final height = globalSize.height -
        headerPadding.vertical -
        10 -
        pagePadding.vertical -
        footerPadding.vertical -
        10;
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
    return BookReaderScope(
      backgroundColor: backgroundColor,
      cursor: cursor,
      duration: duration,
      footerPadding: footerPadding,
      headerPadding: headerPadding,
      index: index,
      isDarkMode: isDarkMode,
      isLoading: isLoading,
      name: widget.name,
      pagePadding: pagePadding,
      pageStyle: pageStyle,
      progress: progress,
      textColor: textColor,
      title: widget.title,
      total: total,
      withExtraButtons: withExtraButtons,
      onCatalogueNavigated: widget.onCatalogueNavigated,
      onChapterDown: handleChapterDown,
      onChapterUp: handleChapterUp,
      onDarkModeChanged: handleDarkModeChanged,
      onOverlayInserted: handleOverlayInserted,
      onOverlayRemoved: handleOverlayRemoved,
      onSliderChanged: handleSliderChanged,
      onSliderChangeEnd: handleSliderChangeEnd,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(color: widget.backgroundColor),
            Builder(builder: (context) {
              if (isLoading) {
                return BookLoading(name: widget.name);
              } else {
                if (hasError) {
                  return const Text('Error');
                } else {
                  return WillPopScope(
                    onWillPop: handleWillPop,
                    child: Stack(
                      children: [
                        BookPage(
                          content: pages.isNotEmpty ? pages[cursor] : '暂无内容',
                          name: widget.name,
                          total: pages.length,
                          onPageDown: () => handlePageDown(pages.length),
                          onPageUp: () => handlePageUp(pages.length),
                        ),
                        if (showOverlay)
                          BookPageOverlay(
                            author: widget.author ?? '',
                            cover: Image.network(''),
                            duration: duration,
                            name: widget.name,
                            onPop: handlePop,
                          )
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

  void hideSystemUiOverlay() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  void showSystemUiOverlay() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
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
      Message.show(context, duration: duration, message: '已经是最后一页');
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
    } else {
      Message.show(context, duration: duration, message: '已经是第一章');
    }
  }

  void handleDarkModeChanged() {
    setState(() {
      isDarkMode = !isDarkMode;
      backgroundColor = isDarkMode ? Colors.black : Colors.white;
      textColor = isDarkMode ? Colors.white : Colors.black;
    });
  }

  void handleOverlayInserted() {
    showSystemUiOverlay();
    setState(() {
      showOverlay = true;
    });
  }

  void handleOverlayRemoved() {
    hideSystemUiOverlay();
    setState(() {
      showOverlay = false;
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
