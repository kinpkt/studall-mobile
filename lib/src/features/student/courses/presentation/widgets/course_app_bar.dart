import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/course_model.dart';
import '../../data/models/course_schedule_model.dart';

class CourseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CourseModel course;
  final TabController tabController;
  final List<String> tabPaths;

  const CourseAppBar({
    super.key,
    required this.course,
    required this.tabController,
    required this.tabPaths,
  });

  static const _dayNames = {
    DayOfWeek.monday: 'จ.',
    DayOfWeek.tuesday: 'อ.',
    DayOfWeek.wednesday: 'พ.',
    DayOfWeek.thursday: 'พฤ.',
    DayOfWeek.friday: 'ศ.',
    DayOfWeek.saturday: 'ส.',
    DayOfWeek.sunday: 'อา.',
  };

  static const _dayColorKeys = {
    DayOfWeek.monday: 'monday',
    DayOfWeek.tuesday: 'tuesday',
    DayOfWeek.wednesday: 'wednesday',
    DayOfWeek.thursday: 'thursday',
    DayOfWeek.friday: 'friday',
    DayOfWeek.saturday: 'saturday',
    DayOfWeek.sunday: 'sunday',
  };

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Size get preferredSize {
    final hasSchedule = course.schedule.isNotEmpty;
    final scheduleHeight = hasSchedule
        ? 8.0 + (28.0 * course.schedule.length)
        : 0.0;
    return Size.fromHeight(36 + 28 + scheduleHeight + 48);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopRow(context, theme, colorScheme),
            _buildSectionRow(theme, colorScheme),
            if (course.schedule.isNotEmpty)
              _buildScheduleSection(theme, colorScheme),
            _buildTabBar(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(
    BuildContext context,
    ShadThemeData theme,
    ShadColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShadIconButton.ghost(
            onPressed: () => context.pop(),
            decoration: ShadDecoration(shape: BoxShape.circle),
            icon: const Icon(PhosphorIconsRegular.arrowLeft),
            height: 40,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              course.name,
              style: theme.textTheme.h4.copyWith(color: colorScheme.foreground),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          ShadIconButton.outline(
            decoration: ShadDecoration(shape: BoxShape.circle),
            onPressed: () {
              // TODO: course settings
            },
            icon: const Icon(PhosphorIconsRegular.gear),
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionRow(ShadThemeData theme, ShadColorScheme colorScheme) {
    final description = course.description ?? '';
    if (description.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 8),
      child: Text(
        description,
        style: theme.textTheme.p.copyWith(color: colorScheme.mutedForeground),
      ),
    );
  }

  Widget _buildScheduleSection(
    ShadThemeData theme,
    ShadColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'เวลาเรียน',
            style: theme.textTheme.custom['medium']?.copyWith(
              color: colorScheme.foreground,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (course.schedule..sort())
                  .map((sch) => _buildScheduleRow(sch, theme, colorScheme))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(
    CourseScheduleModel schedule,
    ShadThemeData theme,
    ShadColorScheme colorScheme,
  ) {
    final dayName = _dayNames[schedule.day] ?? '';
    final dayColorKey = _dayColorKeys[schedule.day] ?? 'thursday';
    final dotColor = colorScheme.custom[dayColorKey] ?? const Color(0xFFDB4D00);
    final textStyle = theme.textTheme.custom['medium']?.copyWith(
      color: colorScheme.mutedForeground,
    );

    final hasTime = schedule.startTime != null && schedule.endTime != null;
    final timeText = hasTime
        ? '${_formatTime(schedule.startTime!)} - ${_formatTime(schedule.endTime!)}'
        : '';

    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(dayName, style: textStyle),
        if (hasTime) ...[
          const SizedBox(width: 4),
          Text(timeText, style: textStyle),
        ],
        if (schedule.location != null && schedule.location!.isNotEmpty) ...[
          Text(', ', style: textStyle),
          Text('ห้อง ', style: textStyle),
          Expanded(
            child: Text(
              schedule.location!,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ],
    );
  }

  Widget _buildTabBar(BuildContext context, ShadColorScheme colorScheme) {
    return TabBar(
      controller: tabController,
      onTap: (index) => context.pushReplacement(
        '/student/courses/${course.id}/${tabPaths[index]}',
      ),
      labelColor: colorScheme.foreground,
      unselectedLabelColor: colorScheme.mutedForeground,
      indicatorColor: colorScheme.primary,
      tabs: const [
        Tab(text: 'ฟอรัม'),
        Tab(text: 'งานของชั้นเรียน'),
        Tab(text: 'บันทึก'),
      ],
    );
  }
}
