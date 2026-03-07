import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:studall/src/core/interfaces/resource_type.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';
import 'package:studall/src/features/student/tasks/data/models/task_model.dart';
import 'package:uuid/uuid.dart';

enum UtilityType implements ResourceType {
  // assignment,
  // shortAnswerQuestion,
  // multipleChoiceQuestion,
  // material,
  note,
  toDo,
  appointment;
  // event,
}

class UtilityModel {
  final String id;
  final String? courseId;
  final UtilityType type;
  final String? title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final bool? isPinned;

  UtilityModel({
    String? id,
    this.courseId,
    required this.type,
    this.title,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.startDateTime,
    this.endDateTime,
    this.isPinned
  }) : id = id ?? const Uuid().v7(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory UtilityModel.fromNoteModel(NoteModel note) {
    return UtilityModel(
      id: note.id,
      courseId: note.courseId,
      type: UtilityType.note,
      title: note.title,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isPinned: note.isPinned
    );
  }

  factory UtilityModel.fromTaskModel(TaskModel task) {
    return UtilityModel(
      id: task.id,
      courseId: task.courseId,
      type: UtilityType.values.byName(task.type.name),
      title: task.title,
      description: task.description,
      startDateTime: task.startDateTime,
      endDateTime: task.endDateTime,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }

  factory UtilityModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return UtilityModel(
      id: data['id'] as String,
      courseId: data['courseId'] as String?,
      type: UtilityType.values.byName(data['type'] as String),
      title: data['title'] as String?,
      description: data['description'] as String?,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      startDateTime: data['startDateTime'] != null ? (data['startDateTime'] as Timestamp).toDate() : null,
      endDateTime: data['endDateTime'] != null ? (data['endDateTime'] as Timestamp).toDate() : null,
      isPinned: data['isPinned'] as bool?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      if (courseId != null)
        'courseId': courseId,
      'type': type.name,
      'title': title,
      if (description != null)
        'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (startDateTime != null)
        'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      if (isPinned != null)
        'isPined': isPinned,
    };
  }
}
