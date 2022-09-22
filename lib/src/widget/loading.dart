import 'package:flutter/material.dart';

import 'footer.dart';
import 'header.dart';

class BookLoading extends StatelessWidget {
  const BookLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          BookPageHeader(),
          Expanded(
            child: Center(child: CircularProgressIndicator.adaptive()),
          ),
          BookPageFooter(),
        ],
      ),
    );
  }

  void handleTap(BuildContext context, TapUpDetails details) {}
}
