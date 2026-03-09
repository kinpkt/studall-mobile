import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_tasks_list_provider.dart';
import '../widgets/task_list_helpers.dart';

class StudentDoneTasksScreen extends ConsumerWidget {
  const StudentDoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(studentTasksListProvider);

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (tasks) {
        final finishedTasks = tasks.where((task) => task.isDone).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              buildExpansionTaskList(context, 'เสร็จก่อนกำหนด',
                  filterDoneBeforeDueTasks(finishedTasks)),
              buildExpansionTaskList(
                  context, 'สัปดาห์นี้', filterThisWeekTasks(finishedTasks)),
              buildExpansionTaskList(context, 'สัปดาห์ถัดไป',
                  filterNextWeekTasks(finishedTasks)),
              buildExpansionTaskList(
                  context, 'ไว้ทีหลัง', filterLaterTasks(finishedTasks)),
              const SizedBox(height: 56 * 2),
            ],
          ),
        );
      },
    );
  }
}
