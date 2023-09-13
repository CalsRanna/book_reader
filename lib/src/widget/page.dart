import 'package:book_reader/book_reader.dart';
import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
  const BookPage({
    super.key,
    required this.cursor,
    required this.eInkMode,
    this.error,
    required this.loading,
    required this.modes,
    required this.name,
    required this.pages,
    required this.progress,
    required this.theme,
    required this.title,
    this.onOverlayInserted,
    this.onPageDown,
    this.onPageUp,
    this.onRefresh,
  });

  final int cursor;
  final bool eInkMode;
  final String? error;
  final bool loading;
  final List<PageTurningMode> modes;
  final String name;
  final List<String> pages;
  final double progress;
  final ReaderTheme theme;
  final String title;
  final void Function()? onOverlayInserted;
  final void Function()? onPageDown;
  final void Function()? onPageUp;
  final void Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (eInkMode) {
      child = Center(child: Text('正在加载', style: theme.pageStyle));
    } else {
      child = const Center(child: CircularProgressIndicator());
    }
    final colorScheme = Theme.of(context).colorScheme;
    final errorContainer = colorScheme.errorContainer;
    final onErrorContainer = colorScheme.onErrorContainer;
    if (error != null) {
      child = Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: errorContainer,
          ),
          height: 120,
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error!,
                style: theme.pageStyle.copyWith(
                  color: onErrorContainer,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: onRefresh, child: const Text('重试'))
            ],
          ),
        ),
      );
    } else if (!loading) {
      if (pages.isNotEmpty) {
        child = Container(
          padding: theme.pagePadding,
          width: double.infinity, // 确保文字很少的情况下也要撑开整个屏幕
          child: Text.rich(
            TextSpan(text: pages[cursor], style: theme.pageStyle),
            strutStyle: StrutStyle(
              fontSize: theme.pageStyle.fontSize,
              forceStrutHeight: true,
              height: theme.pageStyle.height,
            ),
            textDirection: theme.textDirection,
          ),
        );
      } else {
        child = Center(child: Text('暂无内容', style: theme.pageStyle));
      }
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
    if (!modes.contains(PageTurningMode.drag)) return;
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
      if (!modes.contains(PageTurningMode.tap)) return;
      onPageUp?.call();
    } else if (position.dx > width / 3 * 2) {
      if (!modes.contains(PageTurningMode.tap)) return;
      onPageDown?.call();
    } else {
      if (position.dy < height / 4) {
        if (!modes.contains(PageTurningMode.tap)) return;
        onPageUp?.call();
      } else if (position.dy > height / 4 * 3) {
        if (!modes.contains(PageTurningMode.tap)) return;
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
        const SizedBox(width: 24),
        Text('${(progress * 100).toStringAsFixed(2)}%'),
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
