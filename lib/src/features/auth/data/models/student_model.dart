import 'package:json_annotation/json_annotation.dart';
import 'package:studall/src/features/home/data/models/schedule_model.dart';
import 'package:studall/src/features/tasks/data/models/task_model.dart';
import './user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel extends UserModel {
  String _institute;
  ScheduleModel _schedule;
  List<TaskModel> tasks = [];

  StudentModel({
    required String institute,
    required ScheduleModel schedule,
    List<TaskModel>? tasks,
    required String id,
    required String email,
    required String username,
    required String fullName,
    String? photoUrl,
    bool isBanned = false,
  })  : _institute = institute,
        _schedule = schedule,
        this.tasks = tasks ?? [],

        super.withBanStatus(
          id: id,
          email: email,
          username: username,
          fullName: fullName,
          photoUrl: photoUrl,
          isBanned: isBanned,
        );

  String get institute => _institute;
  set institute(String value) => _institute = value;

  ScheduleModel get schedule => _schedule;
  set schedule(ScheduleModel value) => _schedule = value;

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$StudentModelToJson(this);
    data.addAll(super.toJson());
    return data;
  }
}