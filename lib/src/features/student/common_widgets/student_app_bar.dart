import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/auth/presentation/controllers/user_profile_provider.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:studall/src/features/student/home/data/models/schedule_model.dart';

import '../home/presentation/providers/home_controller.dart';

class StudentAppbar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String? pageTitle;
  final bool showNextEvent;
  final bool showSubtitle;
  final String? dateText;
  final String? nextClassName;
  final Color? dateColor;
  final String? userInitials;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onAnimationTap;
  final List<Widget>? actions;

  const StudentAppbar({
    super.key,
    this.pageTitle,
    this.showNextEvent = false,
    this.showSubtitle = true,
    this.dateText,
    this.nextClassName,
    this.dateColor,
    this.userInitials,
    this.onNotificationTap,
    this.onProfileTap,
    this.onAnimationTap,
    this.actions,
  });

  @override
  ConsumerState<StudentAppbar> createState() => _StudentAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(94);
}

class _StudentAppbarState extends ConsumerState<StudentAppbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _dateSlideAnimation;
  late Animation<Offset> _classSlideAnimation;
  Timer? _timer;
  DateTime _now = DateTime.now();
  bool _isShowingNextClass = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _dateSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -2.14),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _classSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2.14),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _scheduleNextMinuteUpdate();
  }

  void _toggleAnimation() {
    if (!widget.showNextEvent) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onAnimationTap?.call();
  }

  void _scheduleNextMinuteUpdate() {
    final now = DateTime.now();
    final secondsUntilNextMinute = 60 - now.second;
    _timer = Timer(Duration(seconds: secondsUntilNextMinute), () {
      setState(() {
        _now = DateTime.now();
      });
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        setState(() {
          _now = DateTime.now();
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  String _formatThaiDate(DateTime date) {
    const thaiDays = ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'];
    const thaiMonths = [
      'ม.ค',
      'ก.พ',
      'มี.ค',
      'เม.ย',
      'พ.ค',
      'มิ.ย',
      'ก.ค',
      'ส.ค',
      'ก.ย',
      'ต.ค',
      'พ.ย',
      'ธ.ค',
    ];

    final dayName = thaiDays[date.weekday - 1];
    final day = date.day;
    final monthName = thaiMonths[date.month - 1];

    return '$dayName $day $monthName';
  }

  int? _minutesUntilEvent(ScheduleModel? event) {
    if (event == null) return null;
    final nowMinutes = _now.hour * 60 + _now.minute;
    final eventMinutes = event.startTime.hour * 60 + event.startTime.minute;
    final diff = eventMinutes - nowMinutes;
    return diff > 0 ? diff : null;
  }

  String _getDisplayTitle(ScheduleModel? nextEvent) {
    if (!widget.showNextEvent) {
      if (nextEvent != null && _minutesUntilEvent(nextEvent) != null) {
        _updateAnimation(true);
      } else {
        _updateAnimation(false);
      }
      return widget.pageTitle ?? 'พักผ่อน';
    }

    final minutes = _minutesUntilEvent(nextEvent);

    if (nextEvent == null || minutes == null) {
      _updateAnimation(false);
      return 'พักผ่อนเถอะ';
    }

    if (minutes > 60) {
      _updateAnimation(false);
      return nextEvent.title;
    }

    _updateAnimation(true);

    if (minutes > 45) {
      return 'อีก 1 ชม';
    } else if (minutes > 30) {
      return 'อีก 45 นาที';
    } else if (minutes > 15) {
      return 'อีก 30 นาที';
    } else {
      return 'อีก $minutes นาที';
    }
  }

  void _updateAnimation(bool showNextClass) {
    if (showNextClass == _isShowingNextClass) return;
    _isShowingNextClass = showNextClass;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (showNextClass) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final user = ref.watch(userProfileProvider);

    final schedulesAsync = ref.watch(scheduleProvider);

    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;

    ScheduleModel? nextCourse;

    if (schedulesAsync.hasValue) {
      final schedules = schedulesAsync.value!;

      try {
        nextCourse = schedules.firstWhere((schedule) {
          final endMinutes = schedule.endTime.hour * 60 + schedule.endTime.minute;
          return endMinutes > currentMinutes;
        });
      } catch (e) {
        nextCourse = null;
      }
    }

    return Container(
      color: colorScheme.background,
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Text(
                    _getDisplayTitle(nextCourse),
                    style: textTheme.h2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  if (widget.actions != null) ...widget.actions!,
                  GestureDetector(
                    onTap: widget.onProfileTap,
                    child: user.when(
                      data: (user) {
                        return GestureDetector(
                          onTap: () => context.push('/setting'),
                          child: ShadAvatar(
                            user?.photoUrl,
                            size: const Size.square(40),
                            backgroundColor: colorScheme.muted,
                            placeholder: Text(
                              'SA',
                              style: textTheme.muted.copyWith(
                                color: colorScheme.foreground,
                              ),
                            ),
                          ),
                        );
                      },
                      loading: () => const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, trace) =>
                          Scaffold(body: Center(child: Text('Error: $e'))),
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.showSubtitle
              ? SizedBox(
                  height: 28,
                  width: double.infinity,
                  child: ClipRect(
                    child: Stack(
                      children: [
                        SlideTransition(
                          position: _dateSlideAnimation,
                          child: Text(
                            widget.dateText ?? _formatThaiDate(_now),
                            style: textTheme.h4.copyWith(
                              color: colorScheme.daily,
                            ),
                          ),
                        ),
                        SlideTransition(
                          position: _classSlideAnimation,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'ถัดไป: ',
                                style: textTheme.custom['medium']!.copyWith(
                                  color: colorScheme.daily,
                                ),
                              ),
                              Flexible(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    nextCourse!.title,
                                    style: textTheme.h4.copyWith(
                                      color: colorScheme.daily,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
