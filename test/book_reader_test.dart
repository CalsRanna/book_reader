import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:book_reader/book_reader.dart';

void main() {
  test('adds one to input values', () {
    // final calculator = Calculator();
    final reader = BookReader(
      author: 'authro',
      chapters: const [],
      cover: Image.network('cover'),
      name: 'name',
      onChapterChanged: (index) => Future.value(index.toString()),
    );

    expect(reader.runtimeType, BookReader);
  });
}
