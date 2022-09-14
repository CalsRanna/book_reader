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
    this.backgroundColor,
    required this.chapters,
    required this.cover,
    this.index,
    required this.name,
    this.onBookPressed,
    required this.onChapterChanged,
  });

  final String author;
  final Color? backgroundColor;
  final List<String> chapters;
  final Image cover;
  final int? index;
  final String name;
  final void Function()? onBookPressed;
  final Future<String> Function(int index) onChapterChanged;

  @override
  State<BookReader> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReader> {
  late String content;
  late PageController controller;
  late OverlayEntry entry;
  late int index;
  EdgeInsets padding = const EdgeInsets.all(16);
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
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var pages = snapshot.data as List<String>;
            return PageView.builder(
              controller: controller,
              itemBuilder: (context, i) => BookPage(
                backgroundColor: widget.backgroundColor,
                content: pages[i],
                current: i + 1,
                header: i == 0 ? widget.name : widget.chapters[index],
                total: pages.length,
                onPageDown: (current) => handlePageDown(current, pages.length),
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

  void handlePageDown(int current, int total) {
    if (current < total) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else if (current == total && index < widget.chapters.length) {
      setState(() {
        index = index + 1;
      });
      controller.jumpTo(0);
    }
  }

  void handlePageUp(int current) {
    if (current > 1) {
      controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else if (current == 1 && index > 0) {
      setState(() {
        index = index - 1;
      });
      controller.jumpTo(0);
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
          cover: widget.cover,
          index: index,
          name: widget.name,
          onBookPressed: widget.onBookPressed,
          onCataloguePressed: navigateCatalogue,
          onChapterChanged: handleChapterChanged,
          onPop: handlePop,
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

  void handleChapterChanged(int index) {
    controller.jumpTo(0);
    setState(() {
      this.index = index;
    });
  }

  void handlePop() {
    entry.remove();
    setState(() {
      showOverlay = true;
    });
    Navigator.of(context).pop();
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
