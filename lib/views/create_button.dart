import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}
