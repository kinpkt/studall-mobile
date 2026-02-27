import 'package:uuid/uuid.dart';

enum UtilityType {
  work, // ภาระงานที่ต้องทำ
  material // แหล่งเรียนรู้ต่าง ๆ (ชีท, จดบันทึก, ภาพกระดาน)
}

class UtilityModel {
  final String id;
  final String? courseId;
  final String userId;
  final UtilityType type;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;

  static const _uuid = Uuid();

  UtilityModel({
    String? id, this.courseId, required this.userId, required this.type, required this.title, this.description, DateTime? createdAt, DateTime? updatedAt, this.dueDate
  }) :  id = id ?? _uuid.v7(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory UtilityModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return UtilityModel(
      id: data['id'] as String,
      courseId: data['courseId'] as String?,
      userId: data['userId'],
      type: UtilityType.values.byName(data['type'] as String),
      title: data['title'] as String,
      description: data['description'] as String?,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
      dueDate: data['dueDate'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      if (courseId != null)
        'courseId': courseId,
      'userId': userId,
      'type': type.name,
      'title': title,
      if (description != null)
        'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (dueDate != null)
        'dueDate': dueDate,
    };
  }
}