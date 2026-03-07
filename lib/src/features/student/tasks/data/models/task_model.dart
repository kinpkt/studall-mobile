import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phosphor_flutter/src/phosphor_icon_data.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/interfaces/resource_type.dart';


enum TaskType implements ResourceType {
  toDo,
  appointment;
}

extension TaskTypeExtension on TaskType {
  String get thaiName {
    switch (this) {
      case TaskType.toDo:
        return 'งานที่ต้องทำ';
      case TaskType.appointment:
        return 'นัดหมาย';
    }
  }
}

class TaskModel {
  final String id;
  final String? courseId;
  final String title;
  final String? description;
  final TaskType type;
  final bool isShownInSchedule;
  final bool isDone;
  final DateTime? startDateTime; // เก็บเฉพาะกรณีที่เป็น appointment
  final DateTime endDateTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  TaskModel({
    id,
    this.courseId,
    required this.title,
    this.description,
    required this.type,
    isShownInSchedule,
    isDone,
    this.startDateTime,
    required this.endDateTime,
    createdAt,
    updatedAt,
  }) :  id = id ?? Uuid().v7(),
        isShownInSchedule = isShownInSchedule ?? false,
        isDone = isDone ?? false,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  TaskModel copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    TaskType? type,
    bool? isShownInSchedule,
    bool? isDone,
    DateTime? startDateTime,
    DateTime? endDateTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      isShownInSchedule: isShownInSchedule ?? this.isShownInSchedule,
      isDone: isDone ?? this.isDone,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TaskModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final TaskType enumType = TaskType.values.firstWhere(
      (e) => e.name == data['type'],
      orElse: () => TaskType.toDo,
    );

    return TaskModel(
      id: docId,
      courseId: data['courseId'],
      title: data['title'],
      description: data['description'],
      type: enumType,
      isShownInSchedule: data['isShownInSchedule'] as bool? ?? false,
      isDone: data['isDone'] as bool? ?? false,
      startDateTime: data['startDateTime'] != null ? (data['startDateTime'] as Timestamp).toDate() : null,
      endDateTime: (data['endDateTime'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      if (description != null)
        'description': description,
      'type': type.name,
      'isShownInSchedule': isShownInSchedule,
      'isDone': isDone,
      if (startDateTime != null)
        'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}