import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'task_type.dart';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskType type;
  final CourseModel? course;

  TaskModel({
    String? id,
    required this.title,
    required this.dueDate,
    required this.type,
    this.description,
    this.course,
  }) : id = id ?? const Uuid().v4();

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskType? type,
    CourseModel? course,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      course: course ?? this.course,
    );
  }

  String get formattedDueDate {
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime dueDay = DateTime(dueDate.year, dueDate.month, dueDate.day);

    int dayDifference = dueDay.difference(today).inDays;

    String timeString = '${dueDate.hour.toString().padLeft(2, '0')}:${dueDate.minute.toString().padLeft(2, '0')}';

    const thaiDays = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัสฯ', 'ศุกร์', 'เสาร์', 'อาทิตย์'];
    const thaiMonths = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'
    ];

    if (dayDifference == 0)
      return 'วันนี้ $timeString';
    else if (dayDifference == 1)
      return 'พรุ่งนี้ $timeString';
    else if (dayDifference == -1)
      return 'เมื่อวาน $timeString';
    else if (dayDifference > 1 && dayDifference < 7) {
      String weekday = thaiDays[dueDate.weekday - 1];
      return 'วัน$weekday $timeString';
    }
    else {
      String day = dueDate.day.toString();
      String month = thaiMonths[dueDate.month - 1];

      if (now.year == dueDate.year)
        return '$day $month $timeString';
      else {
        int buddhistYear = dueDate.year + 543;
        return '$day $month $buddhistYear';
      }
    }
  }
}