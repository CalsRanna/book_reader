import 'package:flutter/material.dart';

class BookLoading extends StatelessWidget {
  const BookLoading({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
