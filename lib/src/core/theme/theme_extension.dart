import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
