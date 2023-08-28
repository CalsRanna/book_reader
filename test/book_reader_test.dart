import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:book_reader/book_reader.dart';

void main() {
  test('adds one to input values', () {
    // final calculator = Calculator();
    final reader = BookReader(
      author: 'author',
      cover: Image.network('cover'),
      future: (index) => Future.value('$index'),
      name: 'name',
      total: 100,
    );

    expect(reader.runtimeType, BookReader);
  });
}
