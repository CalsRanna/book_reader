import 'package:book_reader/src/widget/catalogue.dart';
import 'package:book_reader/src/widget/overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tool/paginator.dart';
import 'page.dart';

class BookReader extends StatefulWidget {
  const BookReader({
    super.key,
    required this.author,
    required this.chapters,
    this.index,
    required this.name,
    required this.onChapterChanged,
  });

  final String author;
  final List<String> chapters;
  final int? index;
  final String name;
  final Future<String> Function(int index) onChapterChanged;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late String content;
  late PageController controller;
  late OverlayEntry entry;
  int index = 0;
  EdgeInsets padding = const EdgeInsets.all(16);
  List<String>? pages;
  bool showOverlay = false;
  late Size size;
  double top = 0;

  @override
  void initState() {
    controller = PageController();
    index = widget.index ?? 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    calculateAvailableSize();
    // fetchContent();
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
        globalPadding.vertical -
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
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pages = snapshot.data as List<String>;
            return PageView.builder(
              controller: controller,
              itemBuilder: (context, i) => BookPage(
                content: pages[index],
                current: i + 1,
                header: i == 0 ? widget.name : widget.chapters[index],
                total: pages.length,
                onPageDown: handlePageDown,
                onPageUp: handlePageUp,
                onTap: handleTap,
              ),
              itemCount: pages.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
        future: fetchContent(),
      ),
    );
  }

  void handlePageDown(int current) {
    if (pages != null && current < pages!.length) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void handlePageUp(int current) {
    if (current > 0) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void handleTap() {
    setState(() {
      showOverlay = !showOverlay;
    });
    if (showOverlay) {
      entry = OverlayEntry(
        builder: (context) => BookPageOverlay(
          author: widget.author,
          chapters: widget.chapters,
          name: widget.name,
          onCatalogueTapped: navigateCatalogue,
          onTap: removeOverlay,
        ),
      );
      Overlay.of(context)?.insert(entry);
    }
  }

  void navigateCatalogue() {
    entry.remove();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BookCatalogue(
        chapters: widget.chapters,
        onChapterChanged: handleChapterChanged,
        onWillPop: handleWillPop,
      ),
    ));
  }

  void handleChapterChanged(int index) async {
    controller.jumpTo(0);
    setState(() {
      index = index;
    });
    // await Future.delayed(const Duration(seconds: 1));
    // fetchContent();
  }

  void removeOverlay() {
    entry.remove();
    setState(() {
      showOverlay = false;
    });
  }

  Future<bool> handleWillPop() {
    setState(() {
      showOverlay = false;
    });
    return Future.value(true);
  }
}
