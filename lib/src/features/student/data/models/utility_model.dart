import 'package:uuid/uuid.dart';

enum UtilityType {
  assignment,
  shortAnswerQuestion,
  multipleChoiceQuestion,
  material,
  note,
  event,
}

class UtilityModel {
  final String id;
  final String? courseId;
  final UtilityType type;
  final String? title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final bool? isPined;

  static const _uuid = Uuid();

  UtilityModel({
    String? id,
    this.courseId,
    required this.type,
    this.title,
    this.description,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dueDate,
    this.isPined,
  }) : id = id ?? _uuid.v7(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory UtilityModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return UtilityModel(
      id: data['id'] as String,
      courseId: data['courseId'] as String?,
      type: UtilityType.values.byName(data['type'] as String),
      title: data['title'] as String?,
      description: data['description'] as String?,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      dueDate: data['dueDate'].toDate(),
      isPined: data['isPined'] as bool?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      if (courseId != null) 'courseId': courseId,
      'type': type.name,
      'title': title,
      if (description != null) 'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (dueDate != null) 'dueDate': dueDate,
      if (isPined != null) 'isPined': isPined,
    };
  }
}
