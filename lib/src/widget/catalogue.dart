import 'package:flutter/material.dart';

class BookCatalogue extends StatelessWidget {
  const BookCatalogue({
    super.key,
    required this.chapters,
    required this.onChapterChanged,
    required this.onWillPop,
  });

  final List<String> chapters;
  final void Function(int index) onChapterChanged;
  final Future<bool> Function() onWillPop;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.swap_vert_outlined),
            )
          ],
          leading: IconButton(
            onPressed: () => handlePop(context),
            icon: const Icon(Icons.chevron_left_outlined),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(chapters[index]),
            onTap: () => handleChapterChange(context, index),
          ),
          itemCount: chapters.length,
        ),
      ),
    );
  }

  void handlePop(BuildContext context) {
    onWillPop();
    Navigator.of(context).pop();
  }

  void handleChapterChange(BuildContext context, int index) {
    onWillPop();
    onChapterChanged(index);
    Navigator.of(context).pop();
  }
}
