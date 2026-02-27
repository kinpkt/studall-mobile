import 'package:json_annotation/json_annotation.dart';
import 'package:studall/src/features/student/tasks/data/models/task_model.dart';
import './user_model.dart';
import './role.dart';

class StudentModel extends UserModel {
  final String institute;
  final List<TaskModel> tasks;

  StudentModel({
    required this.institute,
    List<TaskModel>? tasks,
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    super.photoUrl,
    super.isBanned = false,
    super.roles = const [],
  }) : tasks = tasks ?? [];

  @override
  StudentModel copyWith({
    String? institute,
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
