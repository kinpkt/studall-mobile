import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import '../../data/models/schedule_model.dart';

class Schedule extends StatefulWidget {
  final List<ScheduleModel> scheduleItems;
  final double height;

  const Schedule({super.key, required this.scheduleItems, this.height = 208.0});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  static const double minuteToPixelRatio = 2.0;
  static const int totalMinutesInDay = 24 * 60;
  static const double totalWidth = totalMinutesInDay * minuteToPixelRatio;

  late final ScrollController _scrollController;
  late Timer _timer;
  TimeOfDay _currentTime = TimeOfDay.now();

  double get _currentTimeLeft {
    return (_currentTime.hour * 60 + _currentTime.minute) * minuteToPixelRatio;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final offset = (_currentTimeLeft - 16).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.jumpTo(offset);
    });
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      setState(() {
        _currentTime = TimeOfDay.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textScheme = theme.textTheme;

    return Container(
      clipBehavior: Clip.none,
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                _buildTimeHeader(theme),
                Expanded(
                  child: SizedBox(
                    width: totalWidth,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Background time grid
                        ..._buildTimeGrid(theme),

                        // Schedule items
                        ..._buildScheduleCells(context, theme),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: _currentTimeLeft - 2,
              top: -8,
              bottom: -22,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(width: 4, color: colorScheme.daily),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 8.0, 4.0, 0.0),
                    child: Text(
                      '${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}',
                      style: textScheme.small.copyWith(
                        color: colorScheme.daily,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeHeader(ShadThemeData theme) {
    return Container(
      height: 22,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
      ),
      child: SizedBox(
        width: totalWidth,
        child: Stack(
          children: List.generate(25, (hour) {
            return Positioned(
              left: hour * 60 * minuteToPixelRatio,
              child: Container(
                width: 60,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${hour.toString().padLeft(2, '0')}:00',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> _buildTimeGrid(ShadThemeData theme) {
    List<Widget> gridLines = [];

    for (int hour = 0; hour <= 24; hour++) {
      gridLines.add(
        Positioned(
          left: hour * 60 * minuteToPixelRatio,
          top: -22,
          bottom: 0,
          child: Container(width: 1, color: theme.colorScheme.border),
        ),
      );
    }

    for (int hour = 0; hour < 24; hour++) {
      gridLines.add(
        Positioned(
          left: (hour * 60 + 30) * minuteToPixelRatio,
          top: 0,
          bottom: 0,
          child: Container(
            width: 0.5,
            color: theme.colorScheme.border.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return gridLines;
  }

  List<Widget> _buildScheduleCells(BuildContext context, ShadThemeData theme) {
    final items = widget.scheduleItems;
    final rows = List<int>.filled(items.length, 0);

    for (int i = 0; i < items.length; i++) {
      final iStart = items[i].startTime.hour * 60 + items[i].startTime.minute;
      final iEnd = items[i].endTime.hour * 60 + items[i].endTime.minute;
      final usedRows = <int>{};
      for (int j = 0; j < i; j++) {
        final jStart = items[j].startTime.hour * 60 + items[j].startTime.minute;
        final jEnd = items[j].endTime.hour * 60 + items[j].endTime.minute;
        if (iStart < jEnd && jStart < iEnd) {
          usedRows.add(rows[j]);
        }
      }
      int row = 0;
      while (usedRows.contains(row)) {
        row++;
      }
      rows[i] = row;
    }

    return [
      for (int i = 0; i < items.length; i++)
        _buildScheduleCell(context, items[i], theme, rows[i]),
    ];
  }

  Widget _buildScheduleCell(
    BuildContext context,
    ScheduleModel item,
    ShadThemeData theme,
    int row,
  ) {
    final startMinutes = (item.startTime.hour * 60) + item.startTime.minute;
    final endMinutes = (item.endTime.hour * 60) + item.endTime.minute;
    final durationMinutes = endMinutes - startMinutes;

    final leftPosition = startMinutes * minuteToPixelRatio;
    final cellWidth = durationMinutes * minuteToPixelRatio;

    final courseColor = theme.colorScheme.secondary;

    return Positioned(
      left: leftPosition,
      top: (row % 2) * ((widget.height / 2) - 11),
      child: GestureDetector(
        onTap: () => _onScheduleCellTap(item),
        child: Container(
          width: cellWidth,
          height: (widget.height / 2) - 11,
          decoration: BoxDecoration(
            color: courseColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.border, width: 1),
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
                    [
                      item.location,
                    ].where((s) => s != null && s.isNotEmpty).join(' • '),
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

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _onScheduleCellTap(ScheduleModel item) {
    debugPrint('Tapped on: ${item.title}');
  }
}
