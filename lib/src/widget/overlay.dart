import 'package:book_reader/src/tool/message.dart';
import 'package:book_reader/src/widget/scope.dart';
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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      progress = index / BookReaderScope.of(context)!.total;
    });
    super.didChangeDependencies();
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
      BookReaderScope.of(context)!.onOverlayRemoved?.call();
    }
  }

  void handleChapterChanged(int index) {
    if (index < 0) {
      Message.show(context, message: '已经是第一章');
    } else if (index > BookReaderScope.of(context)!.total) {
      Message.show(context, message: '已经是最后一章');
    } else {
      setState(() {
        this.index = index;
      });
      BookReaderScope.of(context)!.onChapterDown?.call();
    }
  }

  void handleProgressChanged(double value) {
    setState(() {
      progress = value;
    });
  }

  void handleProgressChangedEnd(double value) {
    var index = (value * BookReaderScope.of(context)!.total).toInt();
    if (index >= BookReaderScope.of(context)!.total) {
      index = BookReaderScope.of(context)!.total - 1;
    }
    setState(() {
      this.index = index;
    });
    BookReaderScope.of(context)!.onChapterDown?.call();
  }

  void handleNavigateCatalogue() {
    BookReaderScope.of(context)!.onCatalogueNavigated?.call();
  }
}
