import 'package:json_annotation/json_annotation.dart';
import 'package:studall/src/features/courses/data/models/course_model.dart';

part 'semester_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SemesterModel {
  final List<CourseModel> courses;

  const SemesterModel({
    this.courses = const [],
  });

  double? get gpa {
    if (courses.isEmpty) return null;

    double weightedSum = 0.0;
    double totalCredits = 0.0;

    for (final course in courses) {
      final grade = course.grade;
      final credit = course.credit;

      if (grade != null) {
        weightedSum += credit * grade;
        totalCredits += credit;
      }
    }

    if (totalCredits == 0.0) return null;

    return weightedSum / totalCredits;
  }

  factory SemesterModel.fromJson(Map<String, dynamic> json) =>
      _$SemesterModelFromJson(json);

  Map<String, dynamic> toJson() => _$SemesterModelToJson(this);

  SemesterModel copyWith({
    List<CourseModel>? courses,
  }) {
    return SemesterModel(
      courses: courses ?? this.courses,
    );
  }
}