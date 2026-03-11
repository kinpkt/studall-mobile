import 'package:flutter/material.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';

import '../../../../../core/utils/time_conversion.dart';
import '../../../tasks/data/models/task_model.dart';

class ScheduleModel implements Comparable<ScheduleModel> {
  final String title;
  final String? location;
  final DayOfWeek day;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  ScheduleModel({
    required this.title,
    this.location,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  ScheduleModel.fromCourseSchedule(CourseScheduleModel courseSchedule, String courseTitle)
    : title = courseTitle,
      location = courseSchedule.location,
      day = courseSchedule.day,
      startTime = courseSchedule.startTime!,
      endTime = courseSchedule.endTime!;

  ScheduleModel.fromAppointment(TaskModel task)
    : title = task.title,
      location = null,
      day = DayOfWeek.values[task.startDateTime!.weekday-1],
      startTime = TimeOfDay.fromDateTime(task.startDateTime!),
      endTime = TimeOfDay.fromDateTime(task.endDateTime!);

  @override
  int compareTo(ScheduleModel other) {
    if (day.index != other.day.index)
      return day.index.compareTo(other.day.index);

    final int thisStart = timeOfDayToMinute(startTime);
    final int otherStart = timeOfDayToMinute(other.startTime);

    if (thisStart != otherStart)
      return thisStart.compareTo(otherStart);

    final int thisEnd = timeOfDayToMinute(endTime);
    final int otherEnd = timeOfDayToMinute(other.endTime);

    return thisEnd.compareTo(otherEnd);
  }
}
