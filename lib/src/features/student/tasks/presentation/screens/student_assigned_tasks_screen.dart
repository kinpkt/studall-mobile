import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_tasks_list_provider.dart';
import '../widgets/task_list_helpers.dart';

class StudentAssignedTasksScreen extends ConsumerWidget {
  const StudentAssignedTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(studentTasksListProvider);

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (tasks) {
        final today = DateTime.now();
        final assignedTasks = tasks
            .where((task) => task.endDateTime.isAfter(today) && !task.isDone)
            .toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTaskList(
                title: 'สัปดาห์นี้',
                tasks: filterThisWeekTasks(assignedTasks),
                initiallyExpanded: true,
              ),
              ExpansionTaskList(
                title: 'สัปดาห์ถัดไป',
                tasks: filterNextWeekTasks(assignedTasks),
              ),
              ExpansionTaskList(
                title: 'ไว้ทีหลัง',
                tasks: filterLaterTasks(assignedTasks),
              ),
              const SizedBox(height: 56 * 2),
            ],
          ),
        );
      },
    );
  }
}
