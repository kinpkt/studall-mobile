import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/constants/constants.dart';
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
                  _buildAssignedSectionTaskList(context, kDemoTaskTiles),
                  _buildOverdueSectionTaskList(context, kDemoTaskTiles),
                  _buildDoneSectionTaskList(context, kDemoTaskTiles),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignedSectionTaskList(
    BuildContext context,
    List<UtilityModel> tasks,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildExpansionTaskList(context, 'ไม่มีวันครบกำหนด', tasks),
          _buildExpansionTaskList(context, 'สัปดาห์นี้', tasks),
          _buildExpansionTaskList(context, 'สัปดาห์ถัดไป', tasks),
          _buildExpansionTaskList(context, 'ไว้ทีหลัง', tasks),
          const SizedBox(height: 56 * 2),
        ],
      ),
    );
  }

  Widget _buildOverdueSectionTaskList(
    BuildContext context,
    List<UtilityModel> tasks,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildExpansionTaskList(context, 'สัปดาห์นี้', tasks),
          _buildExpansionTaskList(context, 'สัปดาห์ที่ผ่านมา', tasks),
          _buildExpansionTaskList(context, 'ก่อนหน้านี้', tasks),
          const SizedBox(height: 56 * 2),
        ],
      ),
    );
  }

  Widget _buildDoneSectionTaskList(
    BuildContext context,
    List<UtilityModel> tasks,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildExpansionTaskList(context, 'ไม่มีวันครบกำหนด', tasks),
          _buildExpansionTaskList(context, 'เสร็จก่อนกำหนด', tasks),
          _buildExpansionTaskList(context, 'สัปดาห์นี้', tasks),
          _buildExpansionTaskList(context, 'สัปดาห์ถัดไป', tasks),
          _buildExpansionTaskList(context, 'ไว้ทีหลัง', tasks),
          const SizedBox(height: 56 * 2),
        ],
      ),
    );
  }

  Widget _buildExpansionTaskList(
    BuildContext context,
    String title,
    List<UtilityModel> tasks,
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
