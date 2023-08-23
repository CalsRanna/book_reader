import 'package:book_reader/book_reader.dart';
import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({
    super.key,
    required this.cursor,
    required this.loading,
    required this.name,
    required this.pages,
    required this.progress,
    required this.theme,
    required this.title,
    this.onOverlayInserted,
    this.onPageDown,
    this.onPageUp,
  });

  final int cursor;
  final bool loading;
  final String name;
  final List<TextSpan> pages;
  final double progress;
  final ReaderTheme theme;
  final String title;
  final void Function()? onPageDown;
  final void Function()? onPageUp;
  final void Function()? onOverlayInserted;

  @override
  Widget build(BuildContext context) {
    var span = const TextSpan(text: '暂无内容');
    if (pages.isNotEmpty) {
      span = pages[cursor];
    }
    Widget child = const Center(child: CircularProgressIndicator.adaptive());
    if (!loading) {
      child = Container(
        alignment: pages.isEmpty ? Alignment.center : null,
        padding: theme.pagePadding,
        // width: double.infinity,
        child: Text.rich(span, textDirection: theme.textDirection),
      );
    }

    return GestureDetector(
      onTapUp: (details) => handleTap(context, details),
      onHorizontalDragEnd: (details) => handleEnd(context, details),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookPageHeader(
            cursor: cursor,
            name: name,
            padding: theme.headerPadding,
            title: title,
            style: theme.headerStyle,
          ),
          Expanded(child: child),
          BookPageFooter(
            cursor: cursor,
            length: pages.length,
            loading: loading,
            padding: theme.footerPadding,
            progress: progress,
            style: theme.footerStyle,
          ),
        ],
      ),
    );
  }

  void handleEnd(BuildContext context, DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      onPageDown?.call();
    } else {
      onPageUp?.call();
    }
  }

  void handleTap(BuildContext context, TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final position = details.localPosition;
    if (position.dx < width / 3) {
      onPageUp?.call();
    } else if (position.dx > width / 3 * 2) {
      onPageDown?.call();
    } else {
      if (position.dy < height / 4) {
        onPageUp?.call();
      } else if (position.dy > height / 4 * 3) {
        onPageDown?.call();
      } else {
        onOverlayInserted?.call();
      }
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
    required this.length,
    required this.loading,
    required this.padding,
    required this.progress,
    required this.style,
  });

  final int cursor;
  final int length;
  final bool loading;
  final EdgeInsets padding;
  final double progress;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    List<Widget> left = [const Text('获取中')];
    if (!loading && length > 0) {
      left = [
        Text('${cursor + 1}/$length'),
        const SizedBox(width: 16),
        Text('${(progress * 100).toStringAsFixed(1)}%'),
      ];
    }
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

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
            Text('$hour:$minute'),
          ],
        ),
      ),
    );
  }
}
