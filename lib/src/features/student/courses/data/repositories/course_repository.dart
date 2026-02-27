import '../models/course_model.dart';

abstract class CourseRepository {
  Future<List<CourseModel>> getCourses();
  Future<List<CourseModel>> getCoursesByUserId(String userId);
  Future<CourseModel?> getCourseById(String id);
  Future<void> addCourse(CourseModel course);
  Future<void> updateCourse(CourseModel course);
  Future<void> deleteCourse(String id);
}
