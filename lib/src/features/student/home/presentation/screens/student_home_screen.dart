import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/common_widgets/recent_card.dart';
import 'package:studall/src/features/student/tasks/presentation/widgets/task_tile.dart';
import 'package:uuid/uuid.dart';

import '../../../courses/data/models/course_model.dart';
import '../../../tasks/data/models/task_model.dart';
import '../../../tasks/data/models/task_type.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Hardcoded datasource for items:
    List<UtilityModel> items = [
      WorkUtilityModel(
        id: Uuid().v7.toString(),
        courseId: '01418236-682',
        creatorUserId: Uuid().v7.toString(),
        title: 'Deadlock',
        workType: WorkType.assignment,
        creationTime: DateTime(2026, 1, 20),
        updateTime: DateTime(2026, 1, 22),
        dueDateTime: DateTime(2026, 2, 9, 23, 59),
      ),
      MaterialUtilityModel(
        id: Uuid().v7.toString(),
        courseId: '01418236-682',
        creatorUserId: Uuid().v7.toString(),
        title: 'Deadlock',
        materialType: MaterialTypes.material,
        creationTime: DateTime(2026, 1, 20),
        updateTime: DateTime(2026, 1, 22),
      ),
      WorkUtilityModel(
        id: Uuid().v7.toString(),
        courseId: '01418236-682',
        creatorUserId: Uuid().v7.toString(),
        title: 'Deadlock',
        workType: WorkType.shortAnswerQuestion,
        creationTime: DateTime(2026, 1, 20),
        updateTime: DateTime(2026, 1, 22),
        dueDateTime: DateTime(2026, 2, 9, 23, 59),
      ),
    ];

    // Sandbox area for defining hardcoded datasources
    CourseModel demoCourse1 = CourseModel(
      courseId: '01418496',
      name: 'โครงงานวิทยาศาสตร์คอมพิวเตอร์',
      credit: 3,
    );

    CourseModel demoCourse2 = CourseModel(
      courseId: '01418342-65',
      name: 'Mobile Application Design and Development',
      credit: 3,
    );

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
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRecentContent(context, items),
            _buildTaskList(context, demoTasks),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentContent(BuildContext context, List<UtilityModel> items) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'ล่าสุด',
                    style: textTheme.custom['medium']?.copyWith(
                      color: colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ShadBadge.destructive(
                    child: Text('ใหม่', style: textTheme.custom['small']),
                  ),
                ],
              ),

              GestureDetector(
                onTap: () {
                  // TODO: Navigate to full recent items list
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
          const SizedBox(height: 16),
          SizedBox(
            height: 104,
            child: ListView.separated(
              clipBehavior: Clip.none,
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return RecentItemCard(item: items[index]);
              },
            ),
          ),
        ],
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
