import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?) onChanged;
  final Function(BuildContext) deleteFunction;
  final Function(BuildContext) editFunction;
  final int index;

  const ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
    required this.editFunction,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.redAccent,
              borderRadius: BorderRadius.circular(10),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Icon(
                  Icons.drag_handle,
                  color: Colors.black,
                ),
              ),
              Checkbox(
                value: taskCompleted,
                onChanged: onChanged,
                activeColor: Theme.of(context).colorScheme.surface,
                checkColor: Theme.of(context).colorScheme.onSurface,
                side: BorderSide(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 2,
                ),
              ),
              Expanded(
                child: Text(
                  taskName,
                  style: TextStyle(
                    decoration: taskCompleted ? TextDecoration.lineThrough : null,
                    decorationThickness: taskCompleted ? 2.0 : null, // Make the strikethrough line bolder
                    decorationColor: Colors.black,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.onPrimary,
                onPressed: () => editFunction(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}