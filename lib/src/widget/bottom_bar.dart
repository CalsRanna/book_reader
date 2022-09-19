import 'package:flutter/material.dart';

import 'scope.dart';

class BookPageOverlayBottomBar extends StatefulWidget {
  const BookPageOverlayBottomBar({
    super.key,
    required this.duration,
    this.index,
    this.onCatalogueNavigated,
    this.onChapterChanged,
  });

  final Duration duration;
  final int? index;
  final void Function()? onCatalogueNavigated;
  final void Function(int)? onChapterChanged;

  @override
  State<BookPageOverlayBottomBar> createState() =>
      _BookPageOverlayBottomBarState();
}

class _BookPageOverlayBottomBarState extends State<BookPageOverlayBottomBar>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> animation;
  late AnimationController controller;
  late int index;

  @override
  void initState() {
    controller = AnimationController(duration: widget.duration, vsync: this);
    animation = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(controller);
    controller.forward();

    index = widget.index ?? 0;

    super.initState();
  }

  @override
  void dispose() {
    controller.reverse();
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = BookReaderScope.of(context)!.isDarkMode;

    return SlideTransition(
      position: animation,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (BookReaderScope.of(context)!.withExtraButtons)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: BookReaderScope.of(context)?.onListenNavigated,
                      icon: const Icon(Icons.headphones_outlined),
                      label: const Text('听书'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          BookReaderScope.of(context)?.onCommentNavigated,
                      icon: const Icon(Icons.chat_outlined),
                      label: const Text('书评'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: BookReaderScope.of(context)?.onSourceNavigated,
                      icon: const Icon(Icons.change_circle_outlined),
                      label: const Text('换源'),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                TextButton(
                  onPressed: BookReaderScope.of(context)!.onChapterUp,
                  child: const Text('上一章'),
                ),
                Expanded(
                  child: Slider.adaptive(
                    value: BookReaderScope.of(context)!.progress,
                    onChanged: BookReaderScope.of(context)!.onSliderChanged,
                    onChangeEnd: BookReaderScope.of(context)!.onSliderChangeEnd,
                  ),
                ),
                TextButton(
                  onPressed: BookReaderScope.of(context)!.onChapterDown,
                  child: const Text('下一章'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: BookReaderScope.of(context)?.onCatalogueNavigated,
                  child: Column(
                    children: const [
                      Icon(Icons.list_outlined),
                      Text('目录', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: BookReaderScope.of(context)?.onCacheNavigated,
                  child: Column(
                    children: const [
                      Icon(Icons.download_for_offline_outlined),
                      Text('缓存', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: BookReaderScope.of(context)?.onDarkModeChanged,
                  child: Column(
                    children: [
                      Icon(isDarkMode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined),
                      Text(
                        isDarkMode ? '白天' : '夜间',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: BookReaderScope.of(context)?.onSettingNavigated,
                  child: Column(
                    children: const [
                      Icon(Icons.settings_outlined),
                      Text('设置', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
