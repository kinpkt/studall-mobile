import 'package:flutter/material.dart';

class ScheduleModel {
  String id;
  String? courseId;
  String title;
  String? location;
  String? section;
  int dayOfWeek;
  TimeOfDay startTime;
  TimeOfDay endTime;

  ScheduleModel({
    required this.id,
    this.courseId,
    required this.title,
    this.location,
    this.section,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
