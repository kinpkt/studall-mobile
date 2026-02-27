import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:uuid/uuid.dart';

class NoteModel {
  final String id;
  final String title;
  final String content; // Stringified JSON from flutter_quill
  final String? courseId;
  final String userId;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;

  static final _uuid = Uuid();

  NoteModel(
    {
      id,
      required this.title,
      required this.content,
      this.courseId,
      required this.userId,
      isPinned,
      createdAt,
      updatedAt
    }) :  id = id ?? _uuid.v7().toString(),
          isPinned = isPinned ?? false,
          createdAt = createdAt ?? DateTime.now(),
          updatedAt = updatedAt ?? DateTime.now();

  factory NoteModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return NoteModel(
      id: data['id'] as String,
      title: data['title'] as String,
      content: data['content'] as String,
      courseId: data['courseId'] as String?,
      userId: data['userId'] as String,
      isPinned: data['isPinned'] as bool,
      createdAt: data['createdAt'].toDate(),
      updatedAt: data['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'content': content,
      if (courseId != null)
        'courseId': courseId,
      'userId': userId,
      'isPinned': isPinned,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String get timeDifferenceString {
    DateTime now = DateTime.now();

    int totalMonths = (now.year - createdAt.year)*12 + now.month - createdAt.month;

    if (now.day < createdAt.day)
      totalMonths--;

    int years = totalMonths ~/ 12;
    int months = totalMonths % 12;

    Duration difference = now.difference(createdAt);
    int days = difference.inDays;
    int hours = difference.inHours;
    int minutes = difference.inMinutes;

    if (years > 0)
      return '$years ปีที่แล้ว';
    else if (months > 0)
      return '$months เดือนที่แล้ว';
    else if (days > 0)
      return '$days วันที่แล้ว';
    else if (hours > 0)
      return '$hours ชม. ที่แล้ว';
    else if (minutes > 0)
      return '$minutes นาทีที่แล้ว';
    else
      return 'เพิ่งสร้าง';
  }
}