// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
  id: json['id'] as String?,
  courseId: json['courseId'] as String,
  name: json['name'] as String,
  credit: (json['credit'] as num).toDouble(),
  grade: (json['grade'] as num?)?.toDouble(),
  description: json['description'] as String?,
  academicYear: (json['academicYear'] as num?)?.toInt(),
);

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'name': instance.name,
      'credit': instance.credit,
      'grade': instance.grade,
      'description': instance.description,
      'academicYear': instance.academicYear,
    };
