import 'package:uuid/uuid.dart';
import 'course_schedule_model.dart';

class CourseModel {
  final String id;
  final String name;
  final String? description;
  // final double? credit;
  final String userId;
  final String? teacherName;
  final List<CourseScheduleModel> schedule;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  DateTime? inactiveDateTime;

  CourseModel({
    String? id,
    required this.name,
    this.description,
    required this.userId,
    this.teacherName,
    List<CourseScheduleModel>? schedule,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.isActive,
    DateTime? inactiveDateTime
  })  : id = id ?? const Uuid().v7(),
        schedule = schedule ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory CourseModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return CourseModel(
      id: docId,
      name: data['name'] as String,
      description: data['description'] as String?,
      isActive: data['isActive'] as bool,
      userId: data['userId'] as String,
      teacherName: data['teacherName'] as String?,
      schedule: (data['schedule'] as List<dynamic>?)?.map(
        (scheduleData) => CourseScheduleModel.fromFirestore(
          scheduleData as Map<String, dynamic>
        )
      ).toList(),
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      inactiveDateTime: data['inactiveDateTime'] != null ? data['inactiveDateTime'].toDate() : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      if (description != null)
        'description': description!,
      'userId': userId,
      if (teacherName != null)
        'teacherName': teacherName!,
      'schedule': schedule.map(
        (sch) => sch.toFirestore()
      ).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive
    };
  }
}