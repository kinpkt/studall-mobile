import 'package:flutter/material.dart';

/// Dummy screen for course forums (announcements / discussions).
/// Replace with actual implementation.
class CourseForumsScreen extends StatelessWidget {
  final String courseId;

  const CourseForumsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('ฟอรั่มของรายวิชา $courseId'),
    );
  }
}
