import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:studall/src/features/user/courses/data/models/course_model.dart';
import 'task_type.dart';

part 'task_model.g.dart';

@JsonSerializable(explicitToJson: true)
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
  }) : this.id = id ?? const Uuid().v4();

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

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
}