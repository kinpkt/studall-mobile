import '../models/course_model.dart';

abstract class CourseRepository {
  Future<List<CourseModel>> getCourses();
  Future<List<CourseModel>> getCoursesByUserId(String userId);
  Future<CourseModel?> getCourseById(String userId, String courseId);
  Future<void> addCourse(String userId, CourseModel course);
  Future<void> updateCourse(String userId, CourseModel course);
  Future<void> deleteCourse(String userId, String courseId);
}
