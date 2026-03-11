import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/tasks/presentation/providers/student_tasks_list_provider.dart';
import 'package:studall/src/features/student/tasks/presentation/widgets/task_list_helpers.dart';

class CourseTasksScreen extends ConsumerWidget {
  final String courseId;
  const CourseTasksScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final tasksAsync = ref.watch(studentTasksListProvider(userId));

    return tasksAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (tasks) {
        final courseTasks =
            tasks.where((task) => task.courseId == courseId).toList()
              ..sort((a, b) => b.endDateTime.compareTo(a.endDateTime));

        return SingleChildScrollView(
          child: Column(
            children: [
              ExpansionTaskList(
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
