import 'package:book_reader/src/widget/scope.dart';
import 'package:flutter/material.dart';

class BookPageOverlayAppBar extends StatefulWidget {
  const BookPageOverlayAppBar({
    super.key,
    required this.duration,
    this.onPop,
  });

  final Duration duration;
  final void Function()? onPop;

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
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onPop,
                    icon: const Icon(Icons.chevron_left_outlined),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: BookReaderScope.of(context)?.onRefresh,
                    child: Row(
                      children: const [
                        Icon(Icons.refresh_outlined),
                        Text('刷新')
                      ],
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
      ),
    );
  }
}
