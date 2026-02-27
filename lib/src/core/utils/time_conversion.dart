import 'package:flutter/material.dart';

TimeOfDay minuteToTimeOfDay(int minute) {
  int hour = minute ~/ 60;
  TimeOfDay result = TimeOfDay(hour: hour, minute: hour*60-minute);

  return result;
}

int timeOfDayToMinute(TimeOfDay timeOfDay) {
  return timeOfDay.hour * 60 + timeOfDay.minute;
}