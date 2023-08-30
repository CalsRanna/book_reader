import 'package:flutter/material.dart';

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
      color: Theme.of(context).colorScheme.surface,
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
                    height: MediaQuery.of(context).padding.top + 48,
                    width: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
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
                              Text(
                                widget.name,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                widget.author,
                                style: Theme.of(context).textTheme.bodySmall,
                              )
                            ],
                          ),
                          const Spacer(),
                          OutlinedButton(
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
                            Text('刷新'),
                          ],
                        ),
                      )
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
              onPressed: () => handleCached(50),
              child: const Text('50章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => handleCached(100),
              child: const Text('100章'),
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
  final void Function(double)? onSliderChanged;
  final void Function(double)? onSliderChangedEnd;
  final void Function()? onSourcePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
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
                  child: Slider.adaptive(
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
                onPressed: onDarkModePressed,
                child: Column(
                  children: [
                    Icon(darkMode
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined),
                    Text(darkMode ? '白天' : '夜间'),
                  ],
                ),
              ),
              const TextButton(
                onPressed: null,
                child: Column(
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
    );
  }
}
