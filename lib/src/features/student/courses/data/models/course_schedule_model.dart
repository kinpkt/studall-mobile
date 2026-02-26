import 'package:flutter/material.dart';
import 'package:studall/src/core/utils/time_conversion.dart';

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
  String? location;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  CourseScheduleModel({required this.day, this.location, this.startTime, this.endTime});

  factory CourseScheduleModel.fromFirestore(Map<String, dynamic> data) {
    return CourseScheduleModel(
      day: DayOfWeek.values.byName(data['day']),
      location: data['location'] as String?,
      startTime: data['startTime'] != null ? minuteToTimeOfDay(data['startTime']) : null,
      endTime: data['endTime'] != null ? minuteToTimeOfDay(data['endTime']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'day': day.name,
      if (location != null)
        'location': location,
      if (startTime != null)
        'startTime': timeOfDayToMinute(startTime!),
      if (endTime != null)
        'endTime': timeOfDayToMinute(endTime!),
    };
  }
}