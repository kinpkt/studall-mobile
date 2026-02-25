import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/core/utils/datetime_to_thai_string.dart';
import 'package:studall/src/features/student/common_widgets/resource_icon.dart';

import '../../data/models/task_model.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final shadows = theme.shadows;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          ResourceIcon(type: task.type),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontFamily: 'Google Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    color: colorScheme.foreground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  task.label,
                  style: TextStyle(
                    fontFamily: 'Google Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    color: colorScheme.mutedForeground,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Due date
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDueDate(task.dueDateTime!),
                style: TextStyle(
                  fontFamily: 'Google Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: colorScheme.custom['success'] ?? Colors.green,
                ),
              ),
              Text(
                '${task.dueDateTime!.hour.toString().padLeft(2, '0')}:${task.dueDateTime!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontFamily: 'Google Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: colorScheme.custom['success'] ?? Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
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
      // Use Thai day names for other days
      final dayNames = ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'];
      final dayName = dayNames[dueDate.weekday - 1];
      return 'วัน$dayName';
    }
  }
}
