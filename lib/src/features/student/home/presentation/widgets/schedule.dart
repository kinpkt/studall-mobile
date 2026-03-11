import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import '../../data/models/schedule_model.dart';

class Schedule extends StatefulWidget {
  final List<ScheduleModel> scheduleItems;
  final double height;
  
  const Schedule({
    super.key, 
    required this.scheduleItems,
    this.height = 208.0,
  });

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  static const double minuteToPixelRatio = 2.0;
  static const int totalMinutesInDay = 24 * 60;
  static const double totalWidth = totalMinutesInDay * minuteToPixelRatio;
  // static const double headerHeight = 40.0;
  
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border.all(color: theme.colorScheme.border),
      ),
      child: Column(
        children: [
          // Time header
          _buildTimeHeader(theme),
          
          // Schedule content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: SizedBox(
                width: totalWidth,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background time grid
                    ..._buildTimeGrid(theme),
                    
                    // Schedule items
                    ...widget.scheduleItems.map((item) => 
                      _buildScheduleCell(context, item, theme)
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeHeader(ShadThemeData theme) {
    return Container(
      height: 22,
      decoration: BoxDecoration(
        color: theme.colorScheme.muted.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth,
          child: Stack(
            children: List.generate(25, (hour) {
              return Positioned(
                left: hour * 60 * minuteToPixelRatio,
                child: Container(
                  width: 60,
                  height: 14,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: TextStyle(
                      fontFamily: 'Google Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTimeGrid(ShadThemeData theme) {
    List<Widget> gridLines = [];
    
    // Vertical hour lines
    for (int hour = 0; hour <= 24; hour++) {
      gridLines.add(
        Positioned(
          left: hour * 60 * minuteToPixelRatio,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            color: theme.colorScheme.border,
          ),
        ),
      );
    }
    
    // Half-hour lines (lighter)
    for (int hour = 0; hour < 24; hour++) {
      gridLines.add(
        Positioned(
          left: (hour * 60 + 30) * minuteToPixelRatio,
          top: 0,
          bottom: 0,
          child: Container(
            width: 0.5,
            color: theme.colorScheme.border.withOpacity(0.3),
          ),
        ),
      );
    }
    
    return gridLines;
  }

  Widget _buildScheduleCell(BuildContext context, ScheduleModel item, ShadThemeData theme) {
    final startMinutes = (item.startTime.hour * 60) + item.startTime.minute;
    final endMinutes = (item.endTime.hour * 60) + item.endTime.minute;
    final durationMinutes = endMinutes - startMinutes;
    
    final leftPosition = startMinutes * minuteToPixelRatio;
    final cellWidth = durationMinutes * minuteToPixelRatio;
    
    // Get course color based on day of week or use default
    final courseColor = _getCourseColor(item.day, theme);
    
    return Positioned(
      left: leftPosition,
      top: 0,
      child: GestureDetector(
        onTap: () => _onScheduleCellTap(item),
        child: Container(
          width: cellWidth,
          height: (widget.height/2) - 16, // Account for padding
          decoration: BoxDecoration(
            color: courseColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.border,
              width: 1,
            ),
            boxShadow: theme.shadows.sm,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course title
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Google Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.foreground,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 4),
                
                const Spacer(),
                
                // Location and section
                if (item.location != null)
                  Text(
                    [item.location]
                        .where((s) => s != null && s.isNotEmpty)
                        .join(' • '),
                    style: TextStyle(
                      fontFamily: 'Google Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(item.startTime),
                      style: TextStyle(
                        fontFamily: 'Google Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                    Text(
                      _formatTime(item.endTime),
                      style: TextStyle(
                        fontFamily: 'Google Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCourseColor(DayOfWeek dayOfWeek, ShadThemeData theme) {
    return theme.colorScheme.custom[dayOfWeek.name] ?? theme.colorScheme.card;
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _onScheduleCellTap(ScheduleModel item) {
    debugPrint('Tapped on: ${item.title}');
  }
}