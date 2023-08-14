import 'package:flutter/material.dart';

import 'scope.dart';

class BookPageOverlay extends StatefulWidget {
  const BookPageOverlay({super.key});

  @override
  State<BookPageOverlay> createState() => _BookPageOverlayState();
}

class _BookPageOverlayState extends State<BookPageOverlay> {
  bool visible = false;

  @override
  Widget build(BuildContext context) {
    final showCache = BookReaderScope.of(context)!.showCache;
    final showSetting = BookReaderScope.of(context)!.showSetting;

    return GestureDetector(
      onTap: () {
        BookReaderScope.of(context)?.controller.forward();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const BookPageOverlayAppBar(),
            const BookReaderOverlayMask(),
            if (showCache) const BookPageOverlayCache(),
            if (showSetting) const BookPageOverlaySetting(),
            if (!showCache && !showSetting) const BookPageOverlayBottomBar(),
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
    // final controller = BookReaderScope.of(context)?.controller.reverse();
    // if (visible) {
    //   setState(() {
    //     visible = false;
    //   });
    // } else {
    //   BookReaderScope.of(context)!.onOverlayRemoved?.call();
    // }
  }
}

class BookPageOverlayAppBar extends StatelessWidget {
  const BookPageOverlayAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = BookReaderScope.of(context)!.controller;
    final animation = Tween(
      begin: const RelativeRect.fromLTRB(0, -56, 0, 0),
      end: const RelativeRect.fromLTRB(0, 0, 0, 0),
    ).animate(controller);
    return PositionedTransition(
      rect: animation,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Row(
              children: [
                IconButton(
                  onPressed: BookReaderScope.of(context)?.onPop,
                  icon: const Icon(Icons.chevron_left_outlined),
                ),
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: BookReaderScope.of(context)?.onRefresh,
                  child: const Row(
                    children: [Icon(Icons.refresh_outlined), Text('刷新')],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BookReaderOverlayMask extends StatefulWidget {
  const BookReaderOverlayMask({super.key});

  @override
  State<BookReaderOverlayMask> createState() => _BookReaderOverlayMaskState();
}

class _BookReaderOverlayMaskState extends State<BookReaderOverlayMask> {
  @override
  Widget build(BuildContext context) {
    final controller = BookReaderScope.of(context)!.controller;
    final animation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(controller);
    return Expanded(
      child: SlideTransition(
        position: animation,
        child: GestureDetector(
          onTap: handleTap,
          child: Container(color: Colors.transparent),
        ),
      ),
    );
  }

  void handleTap() {
    BookReaderScope.of(context)?.controller.reverse();
  }
}

class BookPageOverlayCache extends StatelessWidget {
  const BookPageOverlayCache({super.key});

  @override
  Widget build(BuildContext context) {
    final index = BookReaderScope.of(context)!.index;
    final total = BookReaderScope.of(context)!.total;
    final amount = total - index;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, 50),
              child: const Text('后面50章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, 100),
              child: const Text('后面100章'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => handleCached(context, amount),
              child: const Text('后面全部'),
            ),
          )
        ],
      ),
    );
  }

  void handleCached(BuildContext context, int amount) {
    BookReaderScope.of(context)!.onCached?.call(amount);
  }
}

class BookPageOverlaySetting extends StatelessWidget {
  const BookPageOverlaySetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text('亮度'),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.light_mode_outlined),
              ),
              Expanded(child: Slider.adaptive(value: 1, onChanged: (value) {})),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.wb_sunny_outlined),
              ),
            ],
          ),
          Row(
            children: [
              const Text('字号'),
              const SizedBox(width: 16),
              OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.text_decrease_outlined),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('18'),
              ),
              OutlinedButton(
                style: ButtonStyle(
                  side: MaterialStateProperty.all(
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                onPressed: () {},
                child: const Icon(Icons.text_increase_outlined),
              ),
              const Expanded(child: SizedBox()),
              TextButton(onPressed: () {}, child: const Text('系统字体'))
            ],
          ),
          // Row(
          //   children: [
          //     const Text('背景'),
          //     const SizedBox(width: 16),
          //     ListView(
          //       scrollDirection: Axis.horizontal,
          //       shrinkWrap: true,
          //       children: [
          //         _CircleButton(color: Colors.white),
          //         _CircleButton(color: Colors.black),
          //         TextButton(onPressed: () {}, child: const Text('自定义'))
          //       ],
          //     )
          //   ],
          // ),
          const _BackgroundList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextButton(
                onPressed: null,
                child: Column(
                  children: [
                    Icon(Icons.animation_outlined),
                    Text('翻页动画'),
                  ],
                ),
              ),
              const TextButton(
                onPressed: null,
                child: Column(
                  children: [
                    Icon(Icons.play_arrow_outlined),
                    Text('自动阅读'),
                  ],
                ),
              ),
              const TextButton(
                onPressed: null,
                child: Column(
                  children: [
                    Icon(Icons.visibility_outlined),
                    Text('护眼模式'),
                  ],
                ),
              ),
              TextButton(
                onPressed: BookReaderScope.of(context)!.onSetting,
                child: const Column(
                  children: [
                    Icon(Icons.more_horiz_outlined),
                    Text('更多'),
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

class _BackgroundList extends StatelessWidget {
  const _BackgroundList();

  @override
  Widget build(BuildContext context) {
    const colors = Colors.primaries;
    return Row(
      children: [
        const Align(child: Text('背景')),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 40,
            child: CustomScrollView(
              scrollDirection: Axis.horizontal,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _CircleButton(color: colors[index]),
                    childCount: colors.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: TextButton(onPressed: () {}, child: const Text('自定义')),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        margin: const EdgeInsets.only(right: 16),
        height: 40,
        width: 40,
        child: const Icon(Icons.check_outlined),
      ),
    );
  }
}

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
                    child: const Column(
                      children: [
                        Icon(Icons.list_outlined),
                        Text('目录'),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: BookReaderScope.of(context)?.onCacheNavigated,
                    child: const Column(
                      children: [
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
                    child: const Column(
                      children: [
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
