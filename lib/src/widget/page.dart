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
  final void Function()? onOverlayInserted;
  final void Function()? onPageDown;
  final void Function()? onPageUp;

  @override
  Widget build(BuildContext context) {
    var span = const TextSpan(text: '暂无内容');
    if (pages.isNotEmpty) {
      span = pages[cursor];
    }
    // final appTheme = Theme.of(context);
    // final colorScheme = appTheme.colorScheme;
    // final primary = colorScheme.primary;
    // final onPrimary = colorScheme.onPrimary;
    // Widget child = Center(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(8),
    //       color: primary,
    //     ),
    //     padding: const EdgeInsets.all(32),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Text('正在加载', style: theme.pageStyle.copyWith(color: onPrimary)),
    //         const SizedBox(height: 16),
    //         CircularProgressIndicator(color: onPrimary),
    //       ],
    //     ),
    //   ),
    // );
    Widget child = const Center(child: CircularProgressIndicator.adaptive());
    if (!loading) {
      var alignment = Alignment.center;
      if (pages.isNotEmpty) {
        alignment = Alignment.centerLeft;
      }
      child = Container(
        alignment: alignment,
        padding: theme.pagePadding,
        width: double.infinity, // 确保文字很少的情况下也要撑开整个屏幕
        child: Text.rich(span, textDirection: theme.textDirection),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragEnd: (details) => handleHorizontalDrag(context, details),
      onTapUp: (details) => handleTap(context, details),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BookPageHeader(
            cursor: cursor,
            name: name,
            padding: theme.headerPadding,
            style: theme.headerStyle,
            title: title,
          ),
          Expanded(child: child),
          _BookPageFooter(
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

  void handleHorizontalDrag(BuildContext context, DragEndDetails details) {
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

class _BookPageHeader extends StatelessWidget {
  const _BookPageHeader({
    required this.cursor,
    required this.name,
    required this.padding,
    required this.style,
    required this.title,
  });

  final int cursor;
  final String name;
  final EdgeInsets padding;
  final TextStyle style;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onBackground = colorScheme.onBackground;

    return Container(
      color: Colors.transparent,
      padding: padding,
      child: Text(
        cursor > 0 ? title : name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style.copyWith(color: onBackground.withOpacity(0.5)),
      ),
    );
  }
}

class _BookPageFooter extends StatelessWidget {
  const _BookPageFooter({
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onBackground = colorScheme.onBackground;

    return Container(
      color: Colors.transparent,
      padding: padding,
      child: DefaultTextStyle.merge(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: style.copyWith(color: onBackground.withOpacity(0.5)),
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
