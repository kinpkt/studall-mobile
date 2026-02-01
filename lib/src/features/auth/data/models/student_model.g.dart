// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
  institute: json['institute'] as String,
  schedule: ScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
  tasks: (json['tasks'] as List<dynamic>?)
      ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  id: json['id'] as String,
  email: json['email'] as String,
  username: json['username'] as String,
  fullName: json['fullName'] as String,
  photoUrl: json['photoUrl'] as String?,
  isBanned: json['isBanned'] as bool? ?? false,
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RoleEnumMap, e))
          .toList() ??
      const [],
);

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'fullName': instance.fullName,
      'photoUrl': instance.photoUrl,
      'isBanned': instance.isBanned,
      'roles': instance.roles.map((e) => _$RoleEnumMap[e]!).toList(),
      'institute': instance.institute,
      'schedule': instance.schedule.toJson(),
      'tasks': instance.tasks.map((e) => e.toJson()).toList(),
    };

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.student: 'student',
  Role.partner: 'partner',
};
