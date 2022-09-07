import 'package:flutter/material.dart';

class BookPageOverlay extends StatefulWidget {
  const BookPageOverlay({
    super.key,
    required this.author,
    required this.chapters,
    required this.name,
    this.onCatalogueTapped,
    this.onTap,
  });

  final String author;
  final List<String> chapters;
  final String name;
  final void Function()? onCatalogueTapped;
  final void Function()? onTap;

  @override
  State<BookPageOverlay> createState() => _BookPageOverlayState();
}

class _BookPageOverlayState extends State<BookPageOverlay> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {},
            child: Row(
              children: const [
                Icon(Icons.refresh_outlined, color: Colors.white),
                Text('刷新', style: TextStyle(color: Colors.white))
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz_outlined),
            onPressed: showModal,
          ),
        ],
        leading: IconButton(
          onPressed: () {},
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
                      Image.network(
                        'https://images-cn.ssl-images-amazon.cn/images/I/51k6CY+4PUL._SY346_.jpg',
                        height: 64,
                      ),
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
                      OutlinedButton(onPressed: () {}, child: const Text('详情')),
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
                    icon: const Icon(Icons.play_arrow_outlined),
                    label: const Text('自动阅读'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.subscriptions_outlined),
                    label: const Text('换源'),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(onPressed: () {}, child: const Text('上一章')),
                Expanded(
                  child: Slider.adaptive(value: 0.5, onChanged: (value) {}),
                ),
                TextButton(onPressed: () {}, child: const Text('下一章')),
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

  void handleNavigateCatalogue() {
    widget.onCatalogueTapped?.call();
  }
}
