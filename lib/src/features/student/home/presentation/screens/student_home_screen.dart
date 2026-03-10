import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/home/presentation/providers/home_controller.dart';
import 'package:studall/src/features/student/home/presentation/widgets/recent_card.dart';
import 'package:studall/src/features/student/tasks/data/models/task_model.dart';
import 'package:studall/src/features/student/tasks/presentation/widgets/task_tile.dart';
import 'package:studall/src/features/student/home/data/models/schedule_model.dart';
import 'package:studall/src/features/student/home/presentation/widgets/schedule.dart';

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilitiesAsync = ref.watch(ownedUtilitiesProvider);
    final tasksAsync = ref.watch(ownedTasksProvider);

    List<ScheduleModel> sampleSchedule = [
      ScheduleModel(
        title: 'Mobile Application Design and Development',
        location: 'SC1-202',
        dayOfWeek: DayOfWeek.monday,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      ScheduleModel(
        title: 'Operating Systems',
        location: 'SC1-104',
        dayOfWeek: DayOfWeek.tuesday, // Tuesday
        startTime: const TimeOfDay(hour: 13, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
      ),
      ScheduleModel(
        title: 'Database Systems',
        location: 'Online',
        dayOfWeek: DayOfWeek.wednesday, // Wednesday
        startTime: const TimeOfDay(hour: 10, minute: 30),
        endTime: const TimeOfDay(hour: 12, minute: 30),
      ),
      ScheduleModel(
        title: 'Senior Project',
        location: 'SC1-301',
        dayOfWeek: DayOfWeek.friday,
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
      ),
    ];

    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      child: Container(
        color: colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Schedule(scheduleItems: sampleSchedule, height: 208),
            const SizedBox(height: 16),
            utilitiesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error loading items: $err')),
              data: (utility) => _buildRecentContent(context, utility),
            ),
            tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Error loading items: $err')),
              data: (task) => _buildTaskList(context, task),
            ),
            // _buildRecentContent(context, kDemoRecentItems),
            // _buildTaskList(context, kDemoTaskTiles),
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
                    color: colorScheme.custom['info']!,
                    decoration: TextDecoration.underline,
                    decorationColor: colorScheme.custom['info']!,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty) ...[
            Container(
              width: double.infinity,
              height: 104,
              decoration: BoxDecoration(
                color: colorScheme.card,
                border: Border.all(color: colorScheme.border, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'ยังไม่มีรายการล่าสุด',
                  style: textTheme.p.copyWith(
                    color: colorScheme.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ] else ...[
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
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context, List<TaskModel> tasks) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final today = DateTime.now();
    final nextWeek = today.add(const Duration(days: 7));

    final thisWeekTasks = tasks
        .where((task) => task.endDateTime.isBefore(nextWeek))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ที่ต้องทำสัปดาห์นี้',
                  style: textTheme.custom['medium']?.copyWith(
                    color: colorScheme.foreground,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${thisWeekTasks.length}',
                      style: textTheme.custom['medium']?.copyWith(
                        color: colorScheme.mutedForeground,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => context.go('/student/tasks'),
                      child: Text(
                        'ทั้งหมด',
                        style: textTheme.muted.copyWith(
                          color: colorScheme.custom['info']!,
                          decoration: TextDecoration.underline,
                          decorationColor: colorScheme.custom['info']!,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (thisWeekTasks.isEmpty) ...[
            Container(
              width: double.infinity,
              height: 68,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.card,
                border: Border.all(color: colorScheme.border, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'ไม่มีงานที่ต้องทำในสัปดาห์นี้',
                  style: textTheme.p.copyWith(
                    color: colorScheme.mutedForeground,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: thisWeekTasks.length,
              itemBuilder: (context, index) {
                final task = thisWeekTasks[index];

                return TaskTile(task: task);
              },
            ),
          ],
        ],
      ),
    );
  }
}
