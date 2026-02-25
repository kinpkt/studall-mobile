import 'package:flutter/material.dart';

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
}

class CourseScheduleModel {
  DayOfWeek day;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  CourseScheduleModel({required this.day, this.startTime, this.endTime});
}