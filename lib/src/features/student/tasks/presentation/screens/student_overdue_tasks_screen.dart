import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_tasks_list_provider.dart';
import '../widgets/task_list_helpers.dart';

class StudentOverdueTasksScreen extends ConsumerWidget {
  const StudentOverdueTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(studentTasksListProvider);

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (tasks) {
        final today = DateTime.now();
        final overdueTasks = tasks
            .where((task) =>
                task.endDateTime.isBefore(today) && !task.isDone)
            .toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              buildExpansionTaskList(
                  context, 'สัปดาห์นี้', filterThisWeekTasks(overdueTasks)),
              buildExpansionTaskList(context, 'สัปดาห์ที่ผ่านมา',
                  filterLastWeekTasks(overdueTasks)),
              buildExpansionTaskList(
                  context, 'ก่อนหน้านี้', filterEarlierTasks(overdueTasks)),
              const SizedBox(height: 56 * 2),
            ],
          ),
        );
      },
    );
  }
}
