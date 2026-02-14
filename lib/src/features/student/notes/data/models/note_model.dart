import 'package:studall/src/features/student/courses/data/models/course_model.dart';

class NoteModel {
  final String uuid;
  final String name;
  final CourseModel course;
  final DateTime createdAt;

  NoteModel(this.uuid, this.name, this.course, this.createdAt);

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