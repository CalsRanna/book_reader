import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookOverlay extends StatefulWidget {
  const BookOverlay({
    super.key,
    required this.author,
    required this.cover,
    required this.darkMode,
    required this.name,
    this.progress = 0,
    this.onCache,
    this.onCataloguePressed,
    this.onChapterDown,
    this.onChapterUp,
    this.onDarkModePressed,
    this.onDetailPressed,
    this.onOverlayRemoved,
    this.onPop,
    this.onRefresh,
    this.onSettingPressed,
    this.onSliderChanged,
    this.onSliderChangedEnd,
    this.onSourcePressed,
  });

  final String author;
  final Widget cover;
  final bool darkMode;
  final String name;
  final double progress;
  final void Function(int)? onCache;
  final void Function()? onCataloguePressed;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function()? onDarkModePressed;
  final void Function()? onDetailPressed;
  final void Function()? onOverlayRemoved;
  final void Function()? onPop;
  final void Function()? onRefresh;
  final void Function()? onSettingPressed;
  final void Function(double)? onSliderChanged;
  final void Function(double)? onSliderChangedEnd;
  final void Function()? onSourcePressed;

  @override
  State<BookOverlay> createState() => _BookOverlayState();
}

class _BookOverlayState extends State<BookOverlay> {
  bool showCache = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BookPageOverlayAppBar(
          author: widget.author,
          cover: widget.cover,
          name: widget.name,
          onCachePressed: handleCachePressed,
          onDetailPressed: widget.onDetailPressed,
          onPop: widget.onPop,
          onRefresh: widget.onRefresh,
        ),
        _BookReaderOverlayMask(onTap: widget.onOverlayRemoved),
        if (showCache) _BookPageOverlayCache(onCache: handleCache),
        _BookPageOverlayBottomBar(
          darkMode: widget.darkMode,
          progress: widget.progress,
          onCataloguePressed: widget.onCataloguePressed,
          onChapterDown: widget.onChapterDown,
          onChapterUp: widget.onChapterUp,
          onDarkModePressed: widget.onDarkModePressed,
          onSettingPressed: widget.onSettingPressed,
          onSliderChanged: widget.onSliderChanged,
          onSliderChangedEnd: widget.onSliderChangedEnd,
          onSourcePressed: widget.onSourcePressed,
        ),
      ],
    );
  }

  void handleCache(int amount) {
    setState(() {
      showCache = false;
    });
    widget.onCache?.call(amount);
  }

  void handleCachePressed() {
    setState(() {
      showCache = !showCache;
    });
  }
}

class _BookPageOverlayAppBar extends StatefulWidget {
  const _BookPageOverlayAppBar({
    required this.author,
    required this.cover,
    required this.name,
    this.onCachePressed,
    this.onDetailPressed,
    this.onPop,
    this.onRefresh,
  });

  final String author;
  final Widget cover;
  final String name;
  final void Function()? onCachePressed;
  final void Function()? onDetailPressed;
  final void Function()? onPop;
  final void Function()? onRefresh;

  @override
  State<_BookPageOverlayAppBar> createState() => _BookPageOverlayAppBarState();
}

class _BookPageOverlayAppBarState extends State<_BookPageOverlayAppBar> {
  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Row(
              children: [
                IconButton(
                  onPressed: widget.onPop,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: widget.onCachePressed,
                  child: const Row(
                    children: [Icon(Icons.file_download_outlined), Text('缓存')],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: () => handlePressed(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleDetailPressed() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
    widget.onDetailPressed?.call();
  }

  void handlePressed(BuildContext context) {
    final overlay = Overlay.of(context);
    if (entry == null) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final background = colorScheme.background;
      final shadow = colorScheme.shadow;
      final textTheme = theme.textTheme;
      final bodyMedium = textTheme.bodyMedium;
      final bodySmall = textTheme.bodySmall;
      entry = OverlayEntry(builder: (context) {
        return Positioned.fill(
          child: Container(
            color: Colors.transparent,
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: handleTap,
                  child: SizedBox(
                    height: MediaQuery.of(context).padding.top + 56,
                    width: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: shadow.withOpacity(0.25),
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                      )
                    ],
                  ),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          widget.cover,
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.name, style: bodyMedium),
                              Text(widget.author, style: bodySmall)
                            ],
                          ),
                          const Spacer(),
                          OutlinedButton(
                            style: const ButtonStyle(
                              minimumSize: MaterialStatePropertyAll(Size.zero),
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                              ),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: handleDetailPressed,
                            child: const Text('详情'),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: handleRefresh,
                        child: const Column(
                          children: [
                            Icon(Icons.refresh_outlined),
                            Text('强制刷新'),
                          ],
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: TextButton(
                      //         onPressed: handleRefresh,
                      //         child: const Column(
                      //           children: [
                      //             Icon(Icons.refresh_outlined),
                      //             Text('强制刷新'),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: TextButton(
                      //         onPressed: handleRefresh,
                      //         child: const Column(
                      //           children: [
                      //             Icon(Icons.lock_outline),
                      //             Text('归档'),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: TextButton(
                      //         onPressed: handleRefresh,
                      //         child: const Column(
                      //           children: [
                      //             Icon(Icons.public_outlined),
                      //             Text('原始网页'),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     const Expanded(child: SizedBox()),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: handleTap,
                    child: const SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
      overlay.insert(entry!);
    } else {
      entry?.remove();
      entry = null;
    }
  }

  void handleRefresh() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
    widget.onRefresh?.call();
  }

  void handleTap() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
  }
}

class _BookReaderOverlayMask extends StatelessWidget {
  const _BookReaderOverlayMask({this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _BookPageOverlayCache extends StatelessWidget {
  const _BookPageOverlayCache({this.onCache});

  final void Function(int)? onCache;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => handleCached(100),
              child: const Text('100章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => handleCached(200),
              child: const Text('200章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => handleCached(0),
              child: const Text('全部'),
            ),
          )
        ],
      ),
    );
  }

  void handleCached(int amount) {
    onCache?.call(amount);
  }
}

class _BookPageOverlayBottomBar extends StatelessWidget {
  const _BookPageOverlayBottomBar({
    this.darkMode = false,
    this.progress = 0,
    this.onCataloguePressed,
    this.onChapterDown,
    this.onChapterUp,
    this.onDarkModePressed,
    this.onSettingPressed,
    this.onSliderChanged,
    this.onSliderChangedEnd,
    this.onSourcePressed,
  });

  final bool darkMode;
  final double progress;
  final void Function()? onCataloguePressed;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function()? onDarkModePressed;
  final void Function()? onSettingPressed;
  final void Function(double)? onSliderChanged;
  final void Function(double)? onSliderChangedEnd;
  final void Function()? onSourcePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Container(
        color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: onChapterUp,
                  child: const Text('上一章'),
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: Slider(
                      value: progress,
                      onChanged: onSliderChanged,
                      onChangeEnd: onSliderChangedEnd,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onChapterDown,
                  child: const Text('下一章'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onCataloguePressed,
                  child: const Column(
                    children: [
                      Icon(Icons.list),
                      Text('目录'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onSourcePressed,
                  child: const Column(
                    children: [
                      Icon(Icons.change_circle_outlined),
                      Text('换源'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => handleDarkModePressed(context),
                  child: Column(
                    children: [
                      Icon(darkMode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined),
                      Text(darkMode ? '白天' : '夜间'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onSettingPressed,
                  child: const Column(
                    children: [
                      Icon(Icons.settings),
                      Text('设置'),
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

  void handleDarkModePressed(BuildContext context) {
    onDarkModePressed?.call();
    final brightness = Theme.of(context).brightness;
    SystemUiOverlayStyle style;
    if (brightness == Brightness.dark) {
      style = SystemUiOverlayStyle.dark;
    } else {
      style = SystemUiOverlayStyle.light;
    }
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}
