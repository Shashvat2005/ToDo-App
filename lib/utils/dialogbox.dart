import 'package:flutter/material.dart';
import 'package:todo/utils/button.dart';

// ignore: must_be_immutable
class Dialogbox extends StatelessWidget {
  final controller;

  VoidCallback onSaved;
  VoidCallback onCancelled;

  Dialogbox({
    super.key,
    required this.controller,
    required this.onSaved,
    required this.onCancelled,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: SizedBox(
          height: 120,
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Add a new Task",
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Button(text: "Save", onPressed: onSaved),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Button(text: "Cancel", onPressed: onCancelled),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
