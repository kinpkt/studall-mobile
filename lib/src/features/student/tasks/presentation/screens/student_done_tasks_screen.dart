import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_tasks_list_provider.dart';
import '../widgets/task_list_helpers.dart';

class StudentDoneTasksScreen extends ConsumerWidget {
  const StudentDoneTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final tasksAsync = ref.watch(studentTasksListProvider(userId));

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (tasks) {
        final finishedTasks = tasks.where((task) => task.isDone).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTaskList(
                title: 'เสร็จก่อนกำหนด',
                tasks: filterDoneBeforeDueTasks(finishedTasks),
              ),
              ExpansionTaskList(
                title: 'สัปดาห์นี้',
                tasks: filterPastThisWeekTasks(finishedTasks),
              ),
              ExpansionTaskList(
                title: 'สัปดาห์ที่ผ่านมา',
                tasks: filterPastLastWeekTasks(finishedTasks),
              ),
              ExpansionTaskList(
                title: 'ก่อนหน้านี้',
                tasks: filterPastEarlierTasks(finishedTasks),
              ),
              const SizedBox(height: 56 * 2),
            ],
          ),
        );
      },
    );
  }
}
