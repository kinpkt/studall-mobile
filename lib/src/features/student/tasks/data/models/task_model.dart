import 'package:json_annotation/json_annotation.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:uuid/uuid.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'task_type.dart';

@JsonSerializable(explicitToJson: true)
class TaskModel {
  final String id;
  final String title;
  final String label;
  final UtilityType type;
  final DateTime? dueDateTime;

  TaskModel({
    String? id,
    required this.title,
    required this.label,
    required this.type,
    this.dueDateTime,
  }) : id = id ?? const Uuid().v4();

  factory TaskModel.fromUtilityModel(UtilityModel? utility) {
    if (utility == null) {
      throw ArgumentError('UtilityModel cannot be null');
    }

    if (utility.type is WorkUtilityType) {
      return TaskModel(
        title: utility.title ?? 'Untitled Task',
        label: utility.courseId,
        type: utility.type,
        dueDateTime: (utility as WorkUtilityModel).dueDateTime,
      );
    }

    return TaskModel(
      title: utility.title ?? 'Untitled Task',
      label: utility.courseId,
      type: utility.type,
    );
  }

  // factory TaskModel.fromJson(Map<String, dynamic> json) =>
  //     _$TaskModelFromJson(json);

  // Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? title,
    String? label,
    DateTime? dueDateTime,
    UtilityType? type,
    CourseModel? course,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      label: label ?? this.label,
      type: type ?? this.type,
      dueDateTime: dueDateTime ?? this.dueDateTime,
    );
  }

  String get formattedDueDate {
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime dueDay = DateTime(
      dueDateTime!.year,
      dueDateTime!.month,
      dueDateTime!.day,
    );

    int dayDifference = dueDay.difference(today).inDays;

    String timeString =
        '${dueDateTime!.hour.toString().padLeft(2, '0')}:${dueDateTime!.minute.toString().padLeft(2, '0')}';

    const thaiDays = [
      'จันทร์',
      'อังคาร',
      'พุธ',
      'พฤหัสฯ',
      'ศุกร์',
      'เสาร์',
      'อาทิตย์',
    ];
    const thaiMonths = [
      'ม.ค.',
      'ก.พ.',
      'มี.ค.',
      'เม.ย.',
      'พ.ค.',
      'มิ.ย.',
      'ก.ค.',
      'ส.ค.',
      'ก.ย.',
      'ต.ค.',
      'พ.ย.',
      'ธ.ค.',
    ];

    if (dayDifference == 0)
      return 'วันนี้ $timeString';
    else if (dayDifference == 1)
      return 'พรุ่งนี้ $timeString';
    else if (dayDifference == -1)
      return 'เมื่อวาน $timeString';
    else if (dayDifference > 1 && dayDifference < 7) {
      String weekday = thaiDays[dueDateTime!.weekday - 1];
      return 'วัน$weekday $timeString';
    } else {
      String day = dueDateTime!.day.toString();
      String month = thaiMonths[dueDateTime!.month - 1];

      if (now.year == dueDateTime!.year)
        return '$day $month $timeString';
      else {
        int buddhistYear = dueDateTime!.year + 543;
        return '$day $month $buddhistYear';
      }
    }
  }
}
