import 'package:json_annotation/json_annotation.dart';
import 'package:studall/src/features/user/home/data/models/schedule_model.dart';
import 'package:studall/src/features/user/tasks/data/models/task_model.dart';
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
    required String id,
    required String email,
    required String username,
    required String fullName,
    String? photoUrl,
    bool isBanned = false,
    List<Role> roles = const [],
  })  :
        this.tasks = tasks ?? [],
        super(
        id: id,
        email: email,
        username: username,
        fullName: fullName,
        photoUrl: photoUrl,
        isBanned: isBanned,
        roles: roles,
      );

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