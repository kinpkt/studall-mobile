import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/tasks/presentation/providers/student_tasks_list_provider.dart';
import 'package:studall/src/features/student/tasks/presentation/widgets/task_tile.dart';

import '../../../tasks/data/models/task_model.dart';

class CourseTasksScreen extends ConsumerWidget {
  final String courseId;

  const CourseTasksScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(studentTasksListProvider);

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (tasks) {
        final courseTasks = tasks
            .where((task) => task.courseId == courseId)
            .toList()
          ..sort((a, b) => b.endDateTime.compareTo(a.endDateTime));

        return SingleChildScrollView(
          child: Column(
            children: [
              _CourseTaskSection(
                title: 'มอบหมายแล้ว',
                tasks: courseTasks,
                initiallyExpanded: true,
              ),
              const SizedBox(height: 56 * 2),
            ],
          ),
        );
      },
    );
  }
}

class _CourseTaskSection extends StatefulWidget {
  final String title;
  final List<TaskModel> tasks;
  final bool initiallyExpanded;

  const _CourseTaskSection({
    required this.title,
    required this.tasks,
    this.initiallyExpanded = false,
  });

  @override
  State<_CourseTaskSection> createState() => _CourseTaskSectionState();
}

class _CourseTaskSectionState extends State<_CourseTaskSection> {
  static const _previewCount = 3;
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final displayTasks =
        _showAll ? widget.tasks : widget.tasks.take(_previewCount).toList();
    final hasMore = widget.tasks.length > _previewCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        minTileHeight: 24.0,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          widget.title,
          style: textTheme.muted.copyWith(
            color: colorScheme.foreground,
          ),
        ),
        childrenPadding: EdgeInsets.zero,
        children: [
          ...displayTasks.map((task) => TaskTile(task: task)),
          if (hasMore && !_showAll)
            TextButton(
              onPressed: () => setState(() => _showAll = true),
              child: Text(
                'ดูเพิ่ม',
                style: textTheme.small.copyWith(
                  color: colorScheme.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
