import 'package:json_annotation/json_annotation.dart';
import 'package:studall/src/features/student/home/data/models/schedule_model.dart';
import 'package:studall/src/features/student/tasks/data/models/task_model.dart';
import './user_model.dart';
import './role.dart';

part 'student_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentModel extends UserModel {
  final String institute;
  final ScheduleModel schedule;
  final List<TaskModel> tasks;

  StudentModel({
    required this.institute,
    required this.schedule,
    List<TaskModel>? tasks,
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    super.photoUrl,
    super.isBanned = false,
    super.roles = const [],
  }) : tasks = tasks ?? [];

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$StudentModelToJson(this);
    data.addAll(super.toJson());
    return data;
  }

  @override
  StudentModel copyWith({
    String? institute,
    ScheduleModel? schedule,
    List<TaskModel>? tasks,
    String? id,
    String? email,
    String? username,
    String? fullName,
    String? photoUrl,
    bool? isBanned,
    Role? lastActiveRole,
    List<Role>? roles,
  }) {
    return StudentModel(
      institute: institute ?? this.institute,
      schedule: schedule ?? this.schedule,
      tasks: tasks ?? this.tasks,
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      isBanned: isBanned ?? this.isBanned,
      roles: roles ?? this.roles,
    );
  }
}
