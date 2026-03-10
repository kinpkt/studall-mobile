import 'package:flutter/material.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';

class ScheduleModel {
  final String title;
  final String? location;
  final DayOfWeek dayOfWeek;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  ScheduleModel({
    required this.title,
    this.location,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
