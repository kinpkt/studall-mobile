import 'package:json_annotation/json_annotation.dart';
import 'activity_model.dart';

part 'schedule_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ScheduleModel {
  // Public final field
  final List<ActivityModel> activities;

  const ScheduleModel({
    this.activities = const [],
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => _$ScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  ScheduleModel copyWith({
    List<ActivityModel>? activities,
  }) {
    return ScheduleModel(
      activities: activities ?? this.activities,
    );
  }
}