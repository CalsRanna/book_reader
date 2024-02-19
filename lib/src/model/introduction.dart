import 'package:flutter/material.dart';

class BookReaderIntroduction {
  final String author;
  final Image cover;
  final String name;
  final String title;

  BookReaderIntroduction({
    required this.author,
    required this.cover,
    required this.name,
    required this.title,
  });

  BookReaderIntroduction copyWith({
    String? author,
    Image? cover,
    String? name,
    String? title,
  }) {
    return BookReaderIntroduction(
      author: author ?? this.author,
      cover: cover ?? this.cover,
      name: name ?? this.name,
      title: title ?? this.title,
    );
  }
}
