import 'package:flutter/material.dart';

import '../../../../../../Model/task_models/task.dart';

Widget buildTaskHeader(BuildContext context, Task task) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          task.label!,
          style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
