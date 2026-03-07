import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/tasks/presentation/providers/student_tasks_list_provider.dart';
import '../../data/models/task_model.dart';
import '../widgets/tasks_tab_bar.dart';
import '../widgets/task_tile.dart';

class StudentTasksScreen extends ConsumerWidget {
  const StudentTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(studentTasksListProvider);

    return tasksAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Error loading tasks: $error')),
      ),
      data: (tasks) {
        final today = DateTime.now();

        final assignedTasks = tasks.where((task) => task.endDateTime.isAfter(today) && !task.isDone).toList();
        final overdueTasks = tasks.where((task) => task.endDateTime.isBefore(today) && !task.isDone).toList();
        final finishedTasks = tasks.where((task) => task.isDone).toList();

        return DefaultTabController(
          length: 3,
          child: Container(
            color: ShadTheme.of(context).colorScheme.background,
            child: Column(
              children: [
                const TasksTabBar(),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildAssignedSectionTaskList(context, assignedTasks),
                      _buildOverdueSectionTaskList(context, overdueTasks),
                      _buildDoneSectionTaskList(context, finishedTasks),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TaskModel> _filterThisWeekTasks(List<TaskModel> tasks) {
    final today = DateTime.now();
    final nextWeek = today.add(Duration(days: 7));

    return tasks.where((task) => task.endDateTime.isAfter(today) && task.endDateTime.isBefore(nextWeek)).toList();
  }

  List<TaskModel> _filterNextWeekTasks(List<TaskModel> tasks) {
    final today = DateTime.now();
    final nextTwoWeeks = today.add(Duration(days: 14));

    return tasks.where((task) => task.endDateTime.isBefore(nextTwoWeeks)).toList();
  }

  List<TaskModel> _filterLaterTasks(List<TaskModel> tasks) {
    final today = DateTime.now();
    final nextWeek = today.add(Duration(days: 7));
    final nextTwoWeeks = today.add(Duration(days: 14));

    return tasks.where((task) => task.endDateTime.isAfter(nextWeek) && task.endDateTime.isAfter(nextTwoWeeks)).toList();
  }

  List<TaskModel> _filterLastWeekTasks(List<TaskModel> tasks) {
    final today = DateTime.now();
    final lastWeek = today.subtract(Duration(days: 7));
    final lastTwoWeeks = today.subtract(Duration(days: 14));

    return tasks.where((task) => task.endDateTime.isBefore(lastWeek) && task.endDateTime.isAfter(lastTwoWeeks)).toList();
  }

  List<TaskModel> _filterEarlierTasks(List<TaskModel> tasks) {
    final today = DateTime.now();
    final lastTwoWeeks = today.subtract(Duration(days: 14));

    return tasks.where((task) => task.endDateTime.isBefore(lastTwoWeeks)).toList();
  }

  List<TaskModel> _filterDoneBeforeDueTasks(List<TaskModel> tasks) {
    final today = DateTime.now();

    return tasks.where((task) => task.endDateTime.isAfter(today) && task.isDone).toList();
  }

  Widget _buildAssignedSectionTaskList(
    BuildContext context,
    List<TaskModel> tasks,
  ) {

    return SingleChildScrollView(
      child: Column(
        children: [
          // _buildExpansionTaskList(context, 'ไม่มีวันครบกำหนด', tasks),
          _buildExpansionTaskList(context, 'สัปดาห์นี้', _filterThisWeekTasks(tasks)),
          _buildExpansionTaskList(context, 'สัปดาห์ถัดไป', _filterNextWeekTasks(tasks)),
          _buildExpansionTaskList(context, 'ไว้ทีหลัง', _filterLaterTasks(tasks)),
          const SizedBox(height: 56 * 2),
        ],
      ),
    );
  }

  Widget _buildOverdueSectionTaskList(
    BuildContext context,
    List<TaskModel> tasks,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildExpansionTaskList(context, 'สัปดาห์นี้', _filterThisWeekTasks(tasks)),
          _buildExpansionTaskList(context, 'สัปดาห์ที่ผ่านมา', _filterLastWeekTasks(tasks)),
          _buildExpansionTaskList(context, 'ก่อนหน้านี้', _filterEarlierTasks(tasks)),
          const SizedBox(height: 56 * 2),
        ],
      ),
    );
  }

  Widget _buildDoneSectionTaskList(
    BuildContext context,
    List<TaskModel> tasks,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // _buildExpansionTaskList(context, 'ไม่มีวันครบกำหนด', tasks),
          _buildExpansionTaskList(context, 'เสร็จก่อนกำหนด', _filterDoneBeforeDueTasks(tasks)),
          _buildExpansionTaskList(context, 'สัปดาห์นี้', _filterThisWeekTasks(tasks)),
          _buildExpansionTaskList(context, 'สัปดาห์ถัดไป', _filterNextWeekTasks(tasks)),
          _buildExpansionTaskList(context, 'ไว้ทีหลัง', _filterLaterTasks(tasks)),
          const SizedBox(height: 56 * 2),
        ],
      ),
    );
  }

  Widget _buildExpansionTaskList(
    BuildContext context,
    String title,
    List<TaskModel> tasks,
  ) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
      child: ExpansionTile(
        minTileHeight: 24.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.custom['medium']?.copyWith(
                color: colorScheme.foreground,
                fontWeight: FontWeight.w400
              ),
            ),
            Text(
              tasks.length.toString(),
              style: textTheme.custom['medium']?.copyWith(
                color: colorScheme.mutedForeground,
                height: 20 / 16,
              ),
            ),
          ],
        ),

        childrenPadding: const EdgeInsets.only(bottom: 6.0),
        children: tasks.map((task) => TaskTile(task: task)).toList(),
      ),
    );
  }
}
