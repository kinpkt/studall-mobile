import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'course_model.g.dart';

@JsonSerializable()
class CourseModel {
  final String id;
  final String courseId;
  final String name;
  final double credit;
  final double? grade;
  final String? description;
  final int? academicYear;

  CourseModel({
    String? id,
    required this.courseId,
    required this.name,
    required this.credit,
    this.grade,
    this.description,
    this.academicYear,
  }) : id = id ?? const Uuid().v4();

  factory CourseModel.fromLetterGrade({
    String? id,
    required String courseId,
    required String name,
    required double credit,
    required String letterGrade,
    String? description,
    int? academicYear,
  }) {
    return CourseModel(
      id: id,
      courseId: courseId,
      name: name,
      credit: credit,
      description: description,
      academicYear: academicYear,
      grade: _letterGradeToNumeric(letterGrade),
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  static double _letterGradeToNumeric(String grade) {
    switch (grade.toUpperCase()) {
      case 'A': return 4.0;
      case 'B+': return 3.5;
      case 'B': return 3.0;
      case 'C+': return 2.5;
      case 'C': return 2.0;
      case 'D+': return 1.5;
      case 'D': return 1.0;
      case 'F': return 0.0;
      default: return 0.0;
    }
  }

  CourseModel copyWith({
    String? id,
    String? courseId,
    String? name,
    double? credit,
    double? grade,
    String? description,
    int? academicYear,
  }) {
    return CourseModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      name: name ?? this.name,
      credit: credit ?? this.credit,
      grade: grade ?? this.grade,
      description: description ?? this.description,
      academicYear: academicYear ?? this.academicYear,
    );
  }
}