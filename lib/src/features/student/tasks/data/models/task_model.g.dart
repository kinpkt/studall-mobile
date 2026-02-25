// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'task_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
//   id: json['id'] as String?,
//   title: json['title'] as String,
//   dueDate: DateTime.parse(json['dueDate'] as String),
//   type: $enumDecode(_$TaskTypeEnumMap, json['type']),
//   description: json['description'] as String?,
//   course: json['course'] == null
//       ? null
//       : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
// );

// Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
//   'id': instance.id,
//   'title': instance.title,
//   'description': instance.description,
//   'dueDate': instance.dueDate.toIso8601String(),
//   'type': _$TaskTypeEnumMap[instance.type]!,
//   'course': instance.course?.toJson(),
// };

// const _$TaskTypeEnumMap = {
//   TaskType.exam: 'exam',
//   TaskType.meeting: 'meeting',
//   TaskType.assignment: 'assignment',
//   TaskType.project: 'project',
//   TaskType.other: 'other',
// };
