import 'package:uuid/uuid.dart';
import '../../../home/data/models/schedule_model.dart';
import 'course_schedule_model.dart';

class CourseModel {
  final String id;
  final String name;
  final String? description;
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
    this.teacherName,
    List<CourseScheduleModel>? schedule,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.isActive,
    this.inactiveDateTime
  })  : id = id ?? const Uuid().v7(),
        schedule = schedule ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();


  List<ScheduleModel> get scheduleModelList {
    List<ScheduleModel> scheduleModelList = [];

    for (CourseScheduleModel sch in schedule) {
      final schedule = ScheduleModel(
        title: name,
        day: sch.day,
        startTime: sch.startTime!,
        endTime: sch.endTime!,
      );

      scheduleModelList.add(schedule);
    }

      return scheduleModelList;
  }

  factory CourseModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return CourseModel(
      id: docId,
      name: data['name'] as String,
      description: data['description'] as String?,
      isActive: data['isActive'] as bool,
      teacherName: data['teacherName'] as String?,
      schedule: (data['schedule'] as List<dynamic>?)?.map(
              (scheduleData) => CourseScheduleModel.fromFirestore(
              scheduleData as Map<String, dynamic>
          )
      ).toList(),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      updatedAt: data['updatedAt']?.toDate() ?? DateTime.now(),
      inactiveDateTime: data['inactiveDateTime']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      if (description != null) 'description': description!,
      if (teacherName != null) 'teacherName': teacherName!,
      'schedule': schedule.map(
              (sch) => sch.toFirestore()
      ).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      if (inactiveDateTime != null) 'inactiveDateTime': inactiveDateTime,
    };
  }
}