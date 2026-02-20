import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const MyFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Kentung',
      child: const Icon(Icons.add),
    );
  }
}