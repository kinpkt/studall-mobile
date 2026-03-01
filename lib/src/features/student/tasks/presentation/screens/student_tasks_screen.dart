import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import '../widgets/tasks_tab_bar.dart';
import '../widgets/task_tile.dart';

class StudentTasksScreen extends StatelessWidget {
  const StudentTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Center(child: Text("หน้ามอบหมายแล้ว")),
                  Center(child: Text("หน้าเลยกำหนด")),
                  Center(child: Text("หน้าเสร็จสิ้น")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<UtilityModel> tasks) {
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
