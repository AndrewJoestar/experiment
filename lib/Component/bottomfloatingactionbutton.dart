import 'package:flutter/material.dart';

class BottomFloatingAction extends StatelessWidget {
  final VoidCallback onPressed;

  const BottomFloatingAction({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'klik',
      child: const Icon(Icons.add),
    );
  }
}