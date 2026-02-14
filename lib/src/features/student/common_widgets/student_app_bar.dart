import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studall/src/features/auth/presentation/providers/auth_state_provider.dart';

class StudentAppbar extends StatefulWidget implements PreferredSizeWidget {
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
  State<StudentAppbar> createState() => _StudentAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(86);
}

class _StudentAppbarState extends State<StudentAppbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _dateSlideAnimation;
  late Animation<Offset> _classSlideAnimation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (!widget.showNextEvent) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onAnimationTap?.call();
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

  String _getNextEventTime() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return 'ถัดไปอีก 1 ชม. ครึ่ง';
    } else if (hour < 18) {
      return 'ถัดไปอีก 30 นาที';
    } else {
      return 'ไม่มีวิชาวันนี้แล้ว';
    }
  }

  String _getDisplayTitle() {
    if (widget.showNextEvent) {
      _toggleAnimation();
      return _getNextEventTime();
    } else if (widget.pageTitle != null) {
      _toggleAnimation();
      return widget.pageTitle!;
    } else {
      return 'สวัสดีครับ';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    _getDisplayTitle(),
                    style: textTheme.h2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      child: Consumer(
                        builder: (context, ref, _) {
                          final authState = ref.watch(authStateProvider);
                          final authRepository = ref.read(
                            authRepositoryProvider,
                          );
                          return authState.when(
                            data: (user) {
                              return GestureDetector(
                                onDoubleTap: () => authRepository.signOut(),
                                child: ShadAvatar(
                                  user!.photoUrl,
                                  size: const Size.square(40),
                                  backgroundColor: colorScheme.muted,
                                  placeholder: Text(
                                    widget.userInitials ?? 'SA',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: colorScheme.foreground,
                                      height: 20 / 12,
                                    ),
                                  ),
                                ),
                              );
                            },
                            loading: () => const Scaffold(
                              body: Center(child: CircularProgressIndicator()),
                            ),
                            error: (e, trace) => Scaffold(
                              body: Center(child: Text('Error: $e')),
                            ),
                          );
                        },
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
                              widget.dateText ??
                                  _formatThaiDate(DateTime.now()),
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
                                Text(
                                  widget.nextClassName ??
                                      'Mobile Application Design',
                                  style: textTheme.h4.copyWith(
                                    color: colorScheme.daily,
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
      ),
    );
  }
}
