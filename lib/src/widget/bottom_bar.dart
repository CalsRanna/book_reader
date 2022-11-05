import 'package:flutter/material.dart';

import 'scope.dart';

class BookPageOverlayBottomBar extends StatelessWidget {
  const BookPageOverlayBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BookReaderScope.of(context)!.controller;
    final isDarkMode = BookReaderScope.of(context)!.isDarkMode;
    final animation = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(controller);
    var style = const TextStyle(fontSize: 12);
    return SlideTransition(
      position: animation,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle.merge(
          style: style,
          child: Column(
            children: [
              if (BookReaderScope.of(context)!.withExtraButtons)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            BookReaderScope.of(context)?.onListenNavigated,
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
                        onPressed:
                            BookReaderScope.of(context)?.onSourceNavigated,
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
                      onChangeEnd:
                          BookReaderScope.of(context)!.onSliderChangeEnd,
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
                    onPressed:
                        BookReaderScope.of(context)?.onCatalogueNavigated,
                    child: Column(
                      children: const [
                        Icon(Icons.list_outlined),
                        Text('目录'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: BookReaderScope.of(context)?.onCacheNavigated,
                    child: Column(
                      children: const [
                        Icon(Icons.download_for_offline_outlined),
                        Text('缓存'),
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
                        Text(isDarkMode ? '白天' : '夜间'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: BookReaderScope.of(context)?.onSettingNavigated,
                    child: Column(
                      children: const [
                        Icon(Icons.settings_outlined),
                        Text('设置'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
