import 'package:flutter/material.dart';

import 'scope.dart';

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
          _BackgroundList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: null,
                child: Column(
                  children: const [
                    Icon(Icons.animation_outlined),
                    Text('翻页动画'),
                  ],
                ),
              ),
              TextButton(
                onPressed: null,
                child: Column(
                  children: const [
                    Icon(Icons.play_arrow_outlined),
                    Text('自动阅读'),
                  ],
                ),
              ),
              TextButton(
                onPressed: null,
                child: Column(
                  children: const [
                    Icon(Icons.visibility_outlined),
                    Text('护眼模式'),
                  ],
                ),
              ),
              TextButton(
                onPressed: BookReaderScope.of(context)!.onSetting,
                child: Column(
                  children: const [
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
  const _BackgroundList({super.key});

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
  const _CircleButton({super.key, this.actived = false, required this.color});

  final bool actived;
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
        child: actived ? const Icon(Icons.check_outlined) : null,
      ),
    );
  }
}
