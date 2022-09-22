import 'package:book_reader/book_reader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: BookReaderDemo(),
  ));
}

class BookReaderDemo extends StatelessWidget {
  const BookReaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => handlePressed(context),
          child: const Text('Book Reader'),
        ),
      ),
    );
  }

  void handlePressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BookReader(
          future: fetchChapter,
          name: 'Book Reader Demo',
        ),
      ),
    );
  }

  Future<String> fetchChapter(int index) async {
    return Future.value('$index');
  }
}
