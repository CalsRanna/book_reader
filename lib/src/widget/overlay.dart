import 'package:flutter/material.dart';

class BookOverlay extends StatefulWidget {
  const BookOverlay({
    super.key,
    required this.darkMode,
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
    this.progress = 0,
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

  @override
  State<BookOverlay> createState() => _BookOverlayState();
}

class _BookOverlayState extends State<BookOverlay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BookPageOverlayAppBar(onTap: widget.onPop, onRefresh: widget.onRefresh),
        BookReaderOverlayMask(onTap: widget.onOverlayRemoved),
        if (widget.showCache) const BookPageOverlayCache(),
        BookPageOverlayBottomBar(
          darkMode: widget.darkMode,
          progress: widget.progress,
          onChapterDown: widget.onChapterDown,
          onChapterUp: widget.onChapterUp,
          onProgressChanged: widget.onProgressChanged,
          onProgressChangedEnd: widget.onProgressChangedEnd,
          onCatalogueNavigated: widget.onCatalogueNavigated,
          onDarkModePressed: widget.onDarkModePressed,
        ),
      ],
    );
  }
}

class BookPageOverlayAppBar extends StatelessWidget {
  const BookPageOverlayAppBar({super.key, this.onTap, this.onRefresh});

  final void Function()? onTap;
  final void Function()? onRefresh;

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
  const BookPageOverlayCache({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, 50),
              child: const Text('50章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, 100),
              child: const Text('100章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, 0),
              child: const Text('全部'),
            ),
          )
        ],
      ),
    );
  }

  void handleCached(BuildContext context, int amount) {}
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
  });

  final bool darkMode;
  final double progress;
  final void Function()? onChapterDown;
  final void Function()? onChapterUp;
  final void Function(double)? onProgressChanged;
  final void Function(double)? onProgressChangedEnd;
  final void Function()? onCatalogueNavigated;
  final void Function()? onDarkModePressed;

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
              const TextButton(
                onPressed: null,
                child: Column(
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
