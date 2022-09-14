import 'package:book_reader/src/widget/catalogue.dart';
import 'package:book_reader/src/widget/query.dart';
import 'package:flutter/material.dart';

class BookPageOverlay extends StatefulWidget {
  const BookPageOverlay({
    super.key,
    required this.author,
    required this.chapters,
    required this.cover,
    required this.duration,
    this.index,
    required this.name,
    this.onBookPressed,
    this.onCatalogueNavigated,
    required this.onChapterChanged,
    this.onOverlayClosed,
    this.onRefresh,
    this.onPop,
  });

  final String author;
  final List<String> chapters;
  final Image cover;
  final Duration duration;
  final int? index;
  final String name;
  final void Function()? onBookPressed;
  final void Function()? onCatalogueNavigated;
  final void Function(int index) onChapterChanged;
  final void Function()? onOverlayClosed;
  final void Function()? onPop;
  final void Function()? onRefresh;

  @override
  State<BookPageOverlay> createState() => _BookPageOverlayState();
}

class _BookPageOverlayState extends State<BookPageOverlay> {
  late int index;
  double progress = 0;
  bool visible = false;

  @override
  void initState() {
    index = widget.index ?? 0;
    progress = index / widget.chapters.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          BookPageOverlayAppBar(
            duration: widget.duration,
            onPop: widget.onPop,
            onRefresh: widget.onRefresh,
          ),
          Expanded(
            child: GestureDetector(
              onTap: handleTap,
              child: Container(color: Colors.transparent),
            ),
          ),
          BookPageOverlayBottomBar(
            duration: widget.duration,
            index: index,
            onCatalogueNavigated: widget.onCatalogueNavigated,
          ),
        ],
      ),
    );
  }

  void handlePop() {
    widget.onPop?.call();
  }

  void showModal() {
    setState(() {
      visible = !visible;
    });
  }

  void handleTap() {
    if (visible) {
      setState(() {
        visible = false;
      });
    } else {
      widget.onOverlayClosed?.call();
    }
  }

  void handleChapterChanged(int index) {
    if (index < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已经是第一章')),
      );
    } else if (index > widget.chapters.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已经是最后一章')),
      );
    } else {
      setState(() {
        this.index = index;
      });
      widget.onChapterChanged(index);
    }
  }

  void handleProgressChanged(double value) {
    setState(() {
      progress = value;
    });
  }

  void handleProgressChangedEnd(double value) {
    var index = (value * widget.chapters.length).toInt();
    if (index >= widget.chapters.length) {
      index = widget.chapters.length - 1;
    }
    setState(() {
      this.index = index;
    });
    widget.onChapterChanged(index);
  }

  void handleNavigateCatalogue() {
    widget.onCatalogueNavigated?.call();
  }
}

class BookPageOverlayAppBar extends StatefulWidget {
  const BookPageOverlayAppBar({
    super.key,
    required this.duration,
    this.onPop,
    this.onRefresh,
  });

  final Duration duration;
  final void Function()? onPop;
  final void Function()? onRefresh;

  @override
  State<BookPageOverlayAppBar> createState() => _BookPageOverlayAppBarState();
}

class _BookPageOverlayAppBarState extends State<BookPageOverlayAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    controller = AnimationController(duration: widget.duration, vsync: this);
    animation = Tween(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(controller);
    controller.forward();
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
    return SlideTransition(
      position: animation,
      child: PhysicalModel(
        color: Colors.black,
        elevation: 0.5,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onPop,
                icon: const Icon(Icons.chevron_left_outlined),
              ),
              const Expanded(child: SizedBox()),
              TextButton(
                onPressed: widget.onRefresh,
                child: Row(
                  children: const [Icon(Icons.refresh_outlined), Text('刷新')],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz_outlined),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  late double progress;

  @override
  void initState() {
    controller = AnimationController(duration: widget.duration, vsync: this);
    animation = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(controller);
    controller.forward();

    index = widget.index ?? 0;
    progress = 0;

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
    return SlideTransition(
      position: animation,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.headphones_outlined),
                    label: const Text('听书'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('评论'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.change_circle_outlined),
                    label: const Text('换源'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () => handleChapterChanged(index - 1),
                  child: const Text('上一章'),
                ),
                Expanded(
                  child: Slider.adaptive(
                    value: progress,
                    onChanged: (value) {},
                    onChangeEnd: (value) {},
                  ),
                ),
                TextButton(
                  onPressed: () => handleChapterChanged(index + 1),
                  child: const Text('下一章'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onCatalogueNavigated,
                  child: Column(
                    children: const [
                      Icon(Icons.list_outlined),
                      Text('目录', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Column(
                    children: const [
                      Icon(Icons.download_for_offline_outlined),
                      Text('缓存', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Column(
                    children: const [
                      Icon(Icons.dark_mode_outlined),
                      Text('夜间', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
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

  void handleChapterChanged(int index) {
    var length = BookReaderQuery.of(context)?.chapters?.length;
    if (index < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('已经是第一章'),
      ));
    } else if (length != null && index >= length) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('已经是最后一章'),
      ));
    } else {
      widget.onChapterChanged?.call(index);
    }
  }
}
