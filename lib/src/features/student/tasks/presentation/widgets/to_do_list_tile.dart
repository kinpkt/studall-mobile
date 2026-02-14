import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../data/models/task_model.dart';

class ToDoListTile extends StatelessWidget {
  final TaskModel task;
  const ToDoListTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Material(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.custom['blue'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            PhosphorIconsRegular.clipboardText,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(task.title, style: theme.textTheme.list,),
        subtitle: Text(task.course?.name ?? '', style: theme.textTheme.muted),
        trailing: Text(task.formattedDueDate,
          style: theme.textTheme.p.copyWith(
            color: theme.colorScheme.custom['success'],
          ),
        ),
      ),
    );
  }
}
