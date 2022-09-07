import 'package:book_reader/widget/catalogue.dart';
import 'package:book_reader/widget/overlay.dart';
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
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    required this.onChapterChanged,
  });

  final String author;
  final List<String> chapters;
  final int? index;
  final String name;
  final EdgeInsets padding;
  final Future<String> Function(int index) onChapterChanged;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late String content;
  late PageController controller;
  late OverlayEntry entry;
  int index = 0;
  List<String>? pages;
  bool showOverlay = false;
  late Size size;

  @override
  void initState() {
    controller = PageController();
    index = widget.index ?? 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    setState(() {
      size = MediaQuery.of(context).size;
    });
    fetchContent();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void fetchContent() async {
    var content = await widget.onChapterChanged(index);

    const headerHeight = 26;
    const footerHeight = 26;
    final width = size.width - widget.padding.horizontal;
    final height = size.height -
        widget.padding.vertical -
        headerHeight -
        footerHeight -
        19;

    setState(() {
      content = content;
      pages = Paginator(size: Size(width, height)).paginate(content);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: showOverlay ? [SystemUiOverlay.top] : [],
    );

    var header = widget.chapters[index];

    return Scaffold(
      body: PageView.builder(
        controller: controller,
        itemBuilder: (context, index) => BookPage(
          content: pages?[index] ?? '',
          current: index + 1,
          header: header,
          total: pages?.length ?? 0,
          onPageDown: handlePageDown,
          onPageUp: handlePageUp,
          onTap: handleTap,
        ),
        itemCount: pages?.length,
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
    var content = await widget.onChapterChanged(index);
    setState(() {
      index = index;
      content = content;
    });
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
