import 'package:uuid/uuid.dart';
import 'course_schedule_model.dart';

class CourseModel {
  final String uid;
  final String name;
  final String? description;
  final double? credit;
  final String userId;
  final String? teacherName;
  final List<CourseScheduleModel> schedule;
  final DateTime createdAt;
  final DateTime updatedAt;

  CourseModel({
    String? uid,
    required this.name,
    this.description,
    this.credit,
    required this.userId,
    this.teacherName,
    List<CourseScheduleModel>? schedule,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : uid = uid ?? const Uuid().v7(),
        schedule = schedule ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}