import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppShadows {
  final List<BoxShadow> sm;
  final List<BoxShadow> md;
  final List<BoxShadow> lg;

  const AppShadows({required this.sm, required this.md, required this.lg});
}

extension ShadowThemeExtension on ShadThemeData {
  AppShadows get shadows {
    return AppShadows(
      sm: [
        BoxShadow(
          color: colorScheme.foreground.withValues(alpha: 0.05),
          blurRadius: 3,
          offset: const Offset(0, 1),
          spreadRadius: 0,
        ),
      ],
      md: [
        BoxShadow(
          color: colorScheme.foreground.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
          spreadRadius: -1,
        ),
        BoxShadow(
          color: colorScheme.foreground.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ],
      lg: [
        BoxShadow(
          color: colorScheme.foreground.withValues(alpha: 0.1),
          blurRadius: 6,
          offset: const Offset(0, 4),
          spreadRadius: -4,
        ),
        BoxShadow(
          color: colorScheme.foreground.withValues(alpha: 0.1),
          blurRadius: 15,
          offset: const Offset(0, 10),
          spreadRadius: -3,
        ),
      ],
    );
  }
}

extension DailyThemeExtension on ShadColorScheme {
  Color get daily {
    final now = DateTime.now();

    switch (now.weekday) {
      case DateTime.sunday:
        return custom['sunday']!;
      case DateTime.monday:
        return custom['monday']!;
      case DateTime.tuesday:
        return custom['tuesday']!;
      case DateTime.wednesday:
        return custom['wednesday']!;
      case DateTime.thursday:
        return custom['thursday']!;
      case DateTime.friday:
        return custom['friday']!;
      case DateTime.saturday:
        return custom['saturday']!;
      default:
        return primary;
    }
  }

  Color get dailyForeground {
    final now = DateTime.now();

    switch (now.weekday) {
      case DateTime.sunday:
        return custom['sundayForeground']!;
      case DateTime.monday:
        return custom['mondayForeground']!;
      case DateTime.tuesday:
        return custom['tuesdayForeground']!;
      case DateTime.wednesday:
        return custom['wednesdayForeground']!;
      case DateTime.thursday:
        return custom['thursdayForeground']!;
      case DateTime.friday:
        return custom['fridayForeground']!;
      case DateTime.saturday:
        return custom['saturdayForeground']!;
      default:
        return primaryForeground;
    }
  }
}
