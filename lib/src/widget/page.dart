import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({
    super.key,
    required this.padding,
    required this.headerPadding,
    required this.footerPadding,
    required this.cursor,
    required this.style,
    required this.pages,
    required this.name,
    required this.title,
    required this.headerStyle,
    required this.footerStyle,
    required this.progress,
    this.onOverlayInserted,
    this.onPageDown,
    this.onPageUp,
  });

  final EdgeInsets padding;
  final EdgeInsets headerPadding;
  final EdgeInsets footerPadding;
  final int cursor;
  final TextStyle style;
  final TextStyle headerStyle;
  final TextStyle footerStyle;
  final List<String> pages;
  final String name;
  final String title;
  final double progress;
  final void Function()? onPageDown;
  final void Function()? onPageUp;
  final void Function()? onOverlayInserted;

  @override
  Widget build(BuildContext context) {
    final content = pages.isNotEmpty ? pages[cursor] : '暂无内容';

    return GestureDetector(
      onTapUp: (details) => handleTap(context, details),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(
            cursor: cursor,
            name: name,
            padding: headerPadding,
            title: title,
            style: headerStyle,
          ),
          Expanded(
            child: Container(
              padding: padding,
              width: double.infinity,
              child: Text(content, style: style),
            ),
          ),
          BookPageFooter(
            cursor: cursor,
            padding: footerPadding,
            pages: pages,
            progress: progress,
            style: footerStyle,
          ),
        ],
      ),
    );
  }

  void handleTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final position = details.globalPosition;
    if (position.dx < width ~/ 3) {
      onPageUp?.call();
    } else if (position.dx > width ~/ 3 * 2) {
      onPageDown?.call();
    } else {
      onOverlayInserted?.call();
    }
  }
}

class BookPageHeader extends StatelessWidget {
  const BookPageHeader({
    super.key,
    required this.name,
    required this.title,
    required this.cursor,
    required this.padding,
    required this.style,
  });

  final String name;
  final String title;
  final TextStyle style;
  final EdgeInsets padding;
  final int cursor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: padding,
      child: Text(
        cursor > 0 ? title : name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

class BookPageFooter extends StatelessWidget {
  const BookPageFooter({
    super.key,
    required this.cursor,
    required this.padding,
    required this.pages,
    required this.progress,
    required this.style,
  });

  final int cursor;
  final EdgeInsets padding;
  final List<String> pages;
  final double progress;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    List<Widget> left = [const Text('获取中')];
    if (pages.isNotEmpty) {
      left = [
        Text('${cursor + 1}/${pages.length}'),
        const SizedBox(width: 8),
        Text('${(progress * 100).toStringAsFixed(2)}%'),
      ];
    }
    return Container(
      color: Colors.transparent,
      padding: padding,
      child: DefaultTextStyle.merge(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style,
        child: Row(
          children: [
            ...left,
            const Expanded(child: SizedBox()),
            Text('${now.hour}:${now.minute.toString().padLeft(2, '0')}'),
          ],
        ),
      ),
    );
  }
}
