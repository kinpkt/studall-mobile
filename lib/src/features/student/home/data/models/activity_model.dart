import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';

part 'activity_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ActivityModel {
  final String id;
  final String name;
  final CourseModel? course;
  final String? location;
  final DateTime startDateTime;
  final DateTime endDateTime;

  ActivityModel({
    String? id,
    required this.name,
    required this.startDateTime,
    required this.endDateTime,
    this.course,
    this.location,
  }) : id = id ?? const Uuid().v4();

  factory ActivityModel.fromJson(Map<String, dynamic> json) => _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  ActivityModel copyWith({
    String? id,
    String? name,
    CourseModel? course,
    String? location,
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      name: name ?? this.name,
      course: course ?? this.course,
      location: location ?? this.location,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
    );
  }
}