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
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.text_decrease_outlined),
              ),
              const Text('18'),
              OutlinedButton(
                onPressed: () {},
                child: const Icon(Icons.text_increase_outlined),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(onPressed: () {}, child: const Text('系统字体'))
            ],
          ),
          Row(
            children: [
              const Text('背景'),
              IconButton(
                onPressed: () {},
                icon: Container(
                  width: 12,
                  height: 12,
                  color: Colors.yellow,
                ),
              ),
              const Expanded(child: SizedBox()),
              ElevatedButton(onPressed: () {}, child: const Text('自定义'))
            ],
          ),
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
