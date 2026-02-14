import 'package:studall/src/features/student/courses/data/models/course_model.dart';

class NoteModel {
  final String uuid;
  final String name;
  final CourseModel course;

  NoteModel(this.uuid, this.name, this.course);
}