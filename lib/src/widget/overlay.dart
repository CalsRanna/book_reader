import 'package:flutter/material.dart';

class BookOverlay extends StatefulWidget {
  const BookOverlay({
    super.key,
    required this.darkMode,
    this.progress = 0,
    required this.showCache,
    this.onOverlayRemoved,
    this.onPop,
    this.onRefresh,
    this.onChapterDown,
    this.onChapterUp,
    this.onProgressChanged,
    this.onProgressChangedEnd,
    this.onCatalogueNavigated,
    this.onDarkModePressed,
    this.onSourceSwitcherPressed,
    this.onCache,
  });

  final bool darkMode;
  final bool showCache;
  final double progress;
  final void Function()? onPop;
  final void Function()? onOverlayRemoved;
  final void Function()? onRefresh;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function(double)? onProgressChanged;
  final void Function(double)? onProgressChangedEnd;
  final void Function()? onCatalogueNavigated;
  final void Function()? onDarkModePressed;
  final void Function()? onSourceSwitcherPressed;
  final void Function(int)? onCache;

  @override
  State<BookOverlay> createState() => _BookOverlayState();
}

class _BookOverlayState extends State<BookOverlay> {
  bool showCache = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BookPageOverlayAppBar(
          onTap: widget.onPop,
          onRefresh: widget.onRefresh,
          onCachePressed: handleCachePressed,
        ),
        BookReaderOverlayMask(onTap: widget.onOverlayRemoved),
        if (showCache) BookPageOverlayCache(onCache: handleCache),
        BookPageOverlayBottomBar(
          darkMode: widget.darkMode,
          progress: widget.progress,
          onChapterDown: widget.onChapterDown,
          onChapterUp: widget.onChapterUp,
          onProgressChanged: widget.onProgressChanged,
          onProgressChangedEnd: widget.onProgressChangedEnd,
          onCatalogueNavigated: widget.onCatalogueNavigated,
          onDarkModePressed: widget.onDarkModePressed,
          onSourceSwitcherPressed: widget.onSourceSwitcherPressed,
        ),
      ],
    );
  }

  void handleCachePressed() {
    setState(() {
      showCache = !showCache;
    });
  }

  void handleCache(int amount) {
    setState(() {
      showCache = false;
    });
    widget.onCache?.call(amount);
  }
}

class BookPageOverlayAppBar extends StatelessWidget {
  const BookPageOverlayAppBar({
    super.key,
    this.onTap,
    this.onRefresh,
    this.onCachePressed,
  });

  final void Function()? onTap;
  final void Function()? onRefresh;
  final void Function()? onCachePressed;

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
                onPressed: onTap,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              const Expanded(child: SizedBox()),
              TextButton(
                onPressed: onCachePressed,
                child: const Row(
                  children: [Icon(Icons.file_download_outlined), Text('缓存')],
                ),
              ),
              TextButton(
                onPressed: onRefresh,
                child: const Row(
                  children: [Icon(Icons.refresh_outlined), Text('刷新')],
                ),
              ),
              // IconButton(
              //   icon: const Icon(Icons.more_horiz_outlined),
              //   onPressed: () {},
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookReaderOverlayMask extends StatefulWidget {
  const BookReaderOverlayMask({super.key, this.onTap});

  final void Function()? onTap;

  @override
  State<BookReaderOverlayMask> createState() => _BookReaderOverlayMaskState();
}

class _BookReaderOverlayMaskState extends State<BookReaderOverlayMask> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class BookPageOverlayCache extends StatelessWidget {
  const BookPageOverlayCache({super.key, this.onCache});

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

class BookPageOverlayBottomBar extends StatelessWidget {
  const BookPageOverlayBottomBar({
    super.key,
    this.darkMode = false,
    this.onChapterDown,
    this.onChapterUp,
    this.onProgressChanged,
    this.onProgressChangedEnd,
    this.onCatalogueNavigated,
    this.progress = 0,
    this.onDarkModePressed,
    this.onSourceSwitcherPressed,
  });

  final bool darkMode;
  final double progress;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function(double)? onProgressChanged;
  final void Function(double)? onProgressChangedEnd;
  final void Function()? onCatalogueNavigated;
  final void Function()? onDarkModePressed;
  final void Function()? onSourceSwitcherPressed;

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
                    onChanged: onProgressChanged,
                    onChangeEnd: onProgressChangedEnd,
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
                onPressed: onCatalogueNavigated,
                child: const Column(
                  children: [
                    Icon(Icons.list),
                    Text('目录'),
                  ],
                ),
              ),
              TextButton(
                onPressed: onSourceSwitcherPressed,
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
