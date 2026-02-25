import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/tasks/presentation/widgets/to_do_list_tile.dart';
import '../../../courses/data/models/course_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_type.dart';
import '../widgets/tasks_tab_bar.dart';
import '../widgets/task_tile.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
   
    List<TaskModel> demoTasks = [
      TaskModel(
        title: 'การบ้านที่ 4 การประเมิอราคา future แปลกๆ',
        label: '01418342-65',
        type: WorkUtilityType(WorkType.assignment),
        dueDateTime: DateTime(2026, 2, 26, 23, 59), // Tomorrow
      ),
      TaskModel(
        title: 'Ass09: Asynchronous Programming',
        label: '01418342-65',
        dueDateTime: DateTime(2026, 2, 27, 23, 59), // Day after tomorrow
        type: WorkUtilityType(WorkType.assignment),
      ),
    ];
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              const TasksTabBar(),
              // TO-DO: group ListTiles into groups based on their deadlines
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        _buildTaskList(context, demoTasks),
                      ],
                    ),
                    // Center(child: Text("หน้ามอบหมายแล้ว")),
                    Center(child: Text("หน้าเลยกำหนด")),
                    Center(child: Text("หน้าเสร็จสิ้น")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskModel> tasks) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with title, count and "See All" link
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Title
                Text(
                  'ที่ต้องทำสัปดาห์นี้',
                  style: textTheme.custom['medium']?.copyWith(
                    color: colorScheme.foreground,
                  ),
                ),

                Row(
                  children: [
                    Text(
                      '${tasks.length}',
                      style: textTheme.custom['medium']?.copyWith(
                        color: colorScheme.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to full todo list
                      },
                      child: Text(
                        'ทั้งหมด',
                        style: textTheme.muted.copyWith(
                          color: colorScheme.mutedForeground,
                          decoration: TextDecoration.underline,
                          decorationColor: colorScheme.mutedForeground,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(task: task);
            },
          ),
        ],
      ),
    );
  }
}
