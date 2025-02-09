import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  final String text;
  VoidCallback onPressed;

  Button({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary, // Border color
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        )
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary, // Text color
        ),
      ),
    );
  }
}
