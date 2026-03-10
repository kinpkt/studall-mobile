import 'package:flutter/material.dart';
import 'package:studall/src/core/utils/time_conversion.dart';

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class CourseScheduleModel implements Comparable<CourseScheduleModel> {
  DayOfWeek day;
  String? location;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  CourseScheduleModel({
    required this.day,
    this.location,
    this.startTime,
    this.endTime,
  });

  factory CourseScheduleModel.fromFirestore(Map<String, dynamic> data) {
    return CourseScheduleModel(
      day: DayOfWeek.values.byName(data['day']),
      location: data['location'] as String?,
      startTime: data['startTime'] != null
          ? minuteToTimeOfDay(data['startTime'])
          : null,
      endTime: data['endTime'] != null
          ? minuteToTimeOfDay(data['endTime'])
          : null,
    );
  }

  void updateWith(
    DayOfWeek? day, {
    String? location,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    this.day = day ?? this.day;
    this.location = location ?? this.location;
    this.startTime = startTime ?? this.startTime;
    this.endTime = endTime ?? this.endTime;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'day': day.name,
      if (location != null) 'location': location,
      if (startTime != null) 'startTime': timeOfDayToMinute(startTime!),
      if (endTime != null) 'endTime': timeOfDayToMinute(endTime!),
    };
  }

  @override
  int compareTo(CourseScheduleModel other) {
    if (day.index != other.day.index)
      return day.index.compareTo(other.day.index);

    final int thisStart = startTime != null ? timeOfDayToMinute(startTime!) : 0;
    final int otherStart = other.startTime != null ? timeOfDayToMinute(other.startTime!) : 0;

    if (thisStart != otherStart)
      return thisStart.compareTo(otherStart);

    final int thisEnd = endTime != null ? timeOfDayToMinute(endTime!) : 0;
    final int otherEnd = other.endTime != null ? timeOfDayToMinute(other.endTime!) : 0;

    return thisEnd.compareTo(otherEnd);
  }
}
