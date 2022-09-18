import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:book_reader/book_reader.dart';

void main() {
  test('adds one to input values', () {
    // final calculator = Calculator();
    final reader = BookReader(
      author: 'authro',
      cover: Image.network('cover'),
      name: 'name',
      total: 100,
      onChapterChanged: (index) => Future.value(index.toString()),
    );

    expect(reader.runtimeType, BookReader);
  });
}
