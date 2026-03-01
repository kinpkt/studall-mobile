import 'package:flutter/material.dart';

/// Dummy screen for course-specific notes.
/// Replace with actual implementation.
class CourseNotesScreen extends StatelessWidget {
  final String courseId;

  const CourseNotesScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('บันทึกของรายวิชา $courseId'),
    );
  }
}
