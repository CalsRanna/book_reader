import 'package:flutter/material.dart';

class BookPageOverlay extends StatefulWidget {
  const BookPageOverlay({
    super.key,
    required this.author,
    required this.chapters,
    required this.cover,
    this.index,
    required this.name,
    this.onBookPressed,
    this.onCataloguePressed,
    required this.onChapterChanged,
    this.onPop,
    this.onTap,
  });

  final String author;
  final List<String> chapters;
  final Image cover;
  final int? index;
  final String name;
  final void Function()? onBookPressed;
  final void Function()? onCataloguePressed;
  final void Function(int index) onChapterChanged;
  final void Function()? onPop;
  final void Function()? onTap;

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
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => handleChapterChanged(index),
            child: Row(
              children: const [Icon(Icons.refresh_outlined), Text('刷新')],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_outlined),
            onPressed: showModal,
          ),
        ],
        leading: IconButton(
          onPressed: handlePop,
          icon: const Icon(Icons.chevron_left_outlined),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          if (visible)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      widget.cover,
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name),
                            Text(widget.author),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: widget.onBookPressed,
                        child: const Text('详情'),
                      ),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: const [
                            Icon(Icons.bookmark_add_outlined),
                            Text('添加书签')
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: const [
                            Icon(Icons.search_outlined),
                            Text('搜索')
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: const [
                            Icon(Icons.find_replace_outlined),
                            Text('过滤净化')
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Column(
                          children: const [
                            Icon(Icons.ios_share_outlined),
                            Text('分享')
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: handleTap,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 185,
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
                    icon: const Icon(Icons.play_circle_outlined),
                    label: const Text('自动阅读'),
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
                    onChanged: handleProgressChanged,
                    onChangeEnd: handleProgressChangedEnd,
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
                  onPressed: handleNavigateCatalogue,
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
      widget.onTap?.call();
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
    widget.onCataloguePressed?.call();
  }
}
