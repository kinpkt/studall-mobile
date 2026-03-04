import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/app_list_tile.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/student/common_widgets/resource_icon.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';

class TaskTile extends StatelessWidget {
  final UtilityModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final dueDateColor = colorScheme.custom['success'] ?? Colors.green;
    final dateStyle = textTheme.muted.copyWith(color: dueDateColor);

    return AppListTile(
      leading: ResourceIcon(type: task.type),
      title: task.title ?? 'Untitled Task',
      titleStyle: textTheme.custom['medium']?.copyWith(
        color: colorScheme.foreground,
      ),
      description: task.courseId ?? '',
      descriptionStyle: textTheme.muted.copyWith(
        color: colorScheme.mutedForeground,
      ),
      trailing: task.dueDate != null
          ? [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_formatDueDate(task.dueDate!), style: dateStyle),
                  Text(
                    '${task.dueDate!.hour.toString().padLeft(2, '0')}:${task.dueDate!.minute.toString().padLeft(2, '0')}',
                    style: dateStyle,
                  ),
                ],
              ),
            ]
          : null,
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (taskDate == today) {
      return 'วันนี้';
    } else if (taskDate == tomorrow) {
      return 'พรุ่งนี้';
    } else {
      final dayNames = ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'];
      final dayName = dayNames[dueDate.weekday - 1];
      return 'วัน $dayName';
    }
  }
}
