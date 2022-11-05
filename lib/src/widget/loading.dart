import 'package:flutter/material.dart';

class BookLoading extends StatelessWidget {
  const BookLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
