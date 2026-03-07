import 'package:flutter/material.dart';

TimeOfDay minuteToTimeOfDay(int minute) {
  int hour = minute ~/ 60;
  TimeOfDay result = TimeOfDay(hour: hour, minute: hour*60-minute);

  return result;
}

int timeOfDayToMinute(TimeOfDay timeOfDay) {
  return timeOfDay.hour * 60 + timeOfDay.minute;
}

DateTime? combineDateTime(DateTime? date, String? timeString) {
  if (date == null || timeString == null || timeString.isEmpty)
    return null;

  final parts = timeString.split(':');
  if (parts.length != 2) return date;

  final hour = int.tryParse(parts[0]) ?? 0;
  final minute = int.tryParse(parts[1]) ?? 0;

  return DateTime(date.year, date.month, date.day, hour, minute);
}