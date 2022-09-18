import 'package:book_reader/src/widget/query.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'bottom_bar.dart';

class BookPageOverlay extends StatefulWidget {
  const BookPageOverlay({
    super.key,
    required this.author,
    required this.cover,
    required this.duration,
    this.index,
    required this.name,
    this.onBookPressed,
    this.onCatalogueNavigated,
    required this.onChapterChanged,
    this.onOverlayClosed,
    this.onPop,
  });

  final String author;
  final Image cover;
  final Duration duration;
  final int? index;
  final String name;
  final void Function()? onBookPressed;
  final void Function()? onCatalogueNavigated;
  final void Function(int index) onChapterChanged;
  final void Function()? onOverlayClosed;
  final void Function()? onPop;

  @override
  State<BookPageOverlay> createState() => _BookPageOverlayState();
}

class _BookPageOverlayState extends State<BookPageOverlay> {
  late int index;
  double progress = 0;
  bool visible = false;

  @override
  void initState() {
    index = widget.index ?? 0;
    progress = index / BookReaderQuery.of(context)!.total;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          BookPageOverlayAppBar(
            duration: widget.duration,
            onPop: widget.onPop,
          ),
          Expanded(
            child: GestureDetector(
              onTap: handleTap,
              child: Container(color: Colors.transparent),
            ),
          ),
          BookPageOverlayBottomBar(
            duration: widget.duration,
            index: index,
            onCatalogueNavigated: widget.onCatalogueNavigated,
          ),
        ],
      ),
    );
  }

  void handlePop() {
    widget.onPop?.call();
  }

  void showModal() {
    setState(() {
      visible = !visible;
    });
  }

  void handleTap() {
    if (visible) {
      setState(() {
        visible = false;
      });
    } else {
      widget.onOverlayClosed?.call();
    }
  }

  void handleChapterChanged(int index) {
    if (index < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已经是第一章')),
      );
    } else if (index > BookReaderQuery.of(context)!.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已经是最后一章')),
      );
    } else {
      setState(() {
        this.index = index;
      });
      widget.onChapterChanged(index);
    }
  }

  void handleProgressChanged(double value) {
    setState(() {
      progress = value;
    });
  }

  void handleProgressChangedEnd(double value) {
    var index = (value * BookReaderQuery.of(context)!.total).toInt();
    if (index >= BookReaderQuery.of(context)!.total) {
      index = BookReaderQuery.of(context)!.total - 1;
    }
    setState(() {
      this.index = index;
    });
    widget.onChapterChanged(index);
  }

  void handleNavigateCatalogue() {
    widget.onCatalogueNavigated?.call();
  }
}
