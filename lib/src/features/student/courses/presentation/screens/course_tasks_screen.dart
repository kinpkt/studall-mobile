import 'package:flutter/material.dart';

/// Dummy screen for course-specific tasks / assignments.
/// Replace with actual implementation.
class CourseTasksScreen extends StatelessWidget {
  final String courseId;

  const CourseTasksScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('งานของรายวิชา $courseId'),
    );
  }
}
