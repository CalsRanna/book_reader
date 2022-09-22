# Book Reader

This is a widget use to read book, since it is still in develop, so DO NOT use it in your product environment.

## Install

```bash
flutter pub add book_reader
```

## Getting started

```dart
import 'package:book_reader/book_reader.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: BookReader(
        future: fetchChapter,
        name: '测试书籍',
      )，
    ),
  ));
}
```
