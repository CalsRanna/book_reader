import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tool/paginator.dart';
import 'overlay.dart';
import 'page.dart';
import 'query.dart';

/// [BookReader] is a widget used to read book. It provide some way to
/// paginate and can be customered by you own choice since we provide
/// many params to do that.
class BookReader extends StatefulWidget {
  const BookReader({
    super.key,
    this.author,
    this.backgroundColor,
    required this.chapters,
    this.cover,
    this.cursor,
    this.duration,
    this.index,
    this.name,
    this.title,
    this.withExtraButtons,
    this.onBookPressed,
    this.onCatalogueNavigated,
    required this.onChapterChanged,
  });

  /// Author of book, can be null if you weren't sure about it.
  final String? author;

  /// If [backgroundColor] is null, the default value is [Colors.white].
  final Color? backgroundColor;
  final List<String> chapters;
  final Image? cover;

  /// The value of [cursor] is the index of pages paginated with style
  /// given. If it is null then the default value is 0.
  final int? cursor;

  /// Duration for animation, include app and bottom bar slide transition,
  /// and page transtion automated.
  final Duration? duration;

  /// Current index of chapters.
  final int? index;

  /// Name of book, used to displayed in header and detail modal.
  final String? name;

  /// Title of chapter, used to displayed in header while is not first page.
  final String? title;

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
  /// data and do some thing you need.
  final Future<String> Function(int index) onChapterChanged;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late String content;
  late PageController controller;
  late int cursor;
  late Duration duration;
  late int index;
  EdgeInsets padding = const EdgeInsets.all(16);
  bool showOverlay = false;
  late Size size;
  late int total;
  late bool withExtraButtons;

  @override
  void initState() {
    cursor = widget.cursor ?? 0;
    duration = widget.duration ?? const Duration(milliseconds: 200);
    index = widget.index ?? 0;
    total = widget.chapters.length;
    withExtraButtons = widget.withExtraButtons ?? true;

    controller = PageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    calculateAvailableSize();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

  Future<List<String>> fetchContent() async {
    var content = await widget.onChapterChanged(index);
    var pages = Paginator(size: size).paginate(content);
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: showOverlay ? [SystemUiOverlay.top] : [],
    );

    return Scaffold(
      body: BookReaderQuery(
        cursor: cursor,
        duration: duration,
        index: index,
        progress: 0,
        total: total,
        withExtraButtons: withExtraButtons,
        child: WillPopScope(
          onWillPop: handleWillPop,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var pages = snapshot.data as List<String>;
                return Stack(
                  children: [
                    PageView.builder(
                      controller: controller,
                      itemBuilder: (context, i) => BookPage(
                        backgroundColor: widget.backgroundColor,
                        content: pages[i],
                        current: i + 1,
                        header: widget.name ?? widget.title ?? '第${i + 1}章',
                        total: pages.length,
                        onPageDown: handlePageDown,
                        onPageUp: handlePageUp,
                        onOverlayOpened: handleTap,
                      ),
                      itemCount: pages.length,
                    ),
                    if (showOverlay)
                      BookPageOverlay(
                        author: '',
                        chapters: [],
                        cover: Image.network(''),
                        duration: duration,
                        name: '',
                        onChapterChanged: (index) {},
                        onPop: handlePop,
                        onOverlayClosed: handleTap,
                      )
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            },
            future: fetchContent(),
          ),
        ),
      ),
    );
  }

  Future<bool> handleWillPop() {
    setState(() {
      showOverlay = false;
    });
    Navigator.of(context).pop();
    return Future.value(true);
  }

  void handlePageDown(int current, int total) {
    if (current < total) {
      controller.nextPage(duration: duration, curve: Curves.linear);
    } else if (current == total && index < this.total - 1) {
      setState(() {
        index = index + 1;
      });
      controller.jumpTo(0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('已经是最后一页'),
      ));
    }
  }

  void handlePageUp(int current) {
    if (current > 1) {
      controller.previousPage(duration: duration, curve: Curves.linear);
    } else if (current == 1 && index > 0) {
      setState(() {
        index = index - 1;
      });
      controller.jumpTo(0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('已经是第一页'),
      ));
    }
  }

  void handleTap() {
    setState(() {
      showOverlay = !showOverlay;
    });
  }

  void handlePop() {
    Navigator.of(context).pop();
  }
}
