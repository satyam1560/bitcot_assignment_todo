import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/src/features/home/data/models/todo.dart';

class ToDoCard extends StatelessWidget {
  const ToDoCard({
    super.key,
    required this.todo,
    required this.color,
  });
  final Color color;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    
    DateTime dueDate = todo.duedate;
    DateTime now = DateTime.now();

    String formattedDueDate = DateFormat('d-MMM').format(dueDate);

    int daysLeft = dueDate.difference(now).inDays;
    Color daysLeftColor = daysLeft <= 1 ? Colors.red : Colors.green;
    return Card(
      elevation: 0,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                todo.title,
                style: textTheme.titleMedium,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formattedDueDate, style: textTheme.labelLarge),
                Text(
                  '$daysLeft days left',
                  style: textTheme.bodyMedium?.copyWith(
                    color: daysLeftColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
