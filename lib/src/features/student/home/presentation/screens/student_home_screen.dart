import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/home/presentation/widgets/recent_card.dart';
import 'package:studall/src/features/student/tasks/presentation/widgets/task_tile.dart';
import 'package:uuid/uuid.dart';
import 'package:studall/src/features/student/home/data/models/schedule_model.dart';
import 'package:studall/src/features/student/home/presentation/widgets/schedule.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ScheduleModel> sampleSchedule = [
      ScheduleModel(
        id: '1',
        courseId: '01418342-65',
        title: 'Mobile Application Design and Development',
        location: 'SC1-202',
        section: 'Sec 1',
        dayOfWeek: 1, // Monday
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      ScheduleModel(
        id: '2',
        courseId: '01418236-65',
        title: 'Operating Systems',
        location: 'SC1-104',
        section: 'Sec 2',
        dayOfWeek: 2, // Tuesday
        startTime: const TimeOfDay(hour: 13, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
      ),
      ScheduleModel(
        id: '3',
        courseId: '01418221-65',
        title: 'Database Systems',
        location: 'Online',
        section: 'Sec 1',
        dayOfWeek: 3, // Wednesday
        startTime: const TimeOfDay(hour: 10, minute: 30),
        endTime: const TimeOfDay(hour: 12, minute: 30),
      ),
      ScheduleModel(
        id: '4',
        courseId: '01418499-65',
        title: 'Senior Project',
        location: 'SC1-301',
        dayOfWeek: 5, // Friday
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
      ),
    ];

    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Schedule(scheduleItems: sampleSchedule, height: 208),
          const SizedBox(height: 16),
          // _buildRecentContent(context, items),
          // _buildTaskList(context, demoTasks),
        ],
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
