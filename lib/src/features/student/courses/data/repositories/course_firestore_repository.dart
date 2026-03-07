import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';

import '../../../../../core/services/firestore_service.dart';
import './course_repository.dart';

final courseFirestoreRepositoryProvider = Provider<CourseFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return CourseFirestoreRepository(firestoreService);
});

class CourseFirestoreRepository implements CourseRepository {
  final FirestoreService _service;

  CourseFirestoreRepository(this._service);

  @override
  Future<void> addCourse(String userId, CourseModel course) async {
    await _service.set(
        path: 'students/$userId/courses/${course.id}',
        data: course.toFirestore()
    );
  }

  @override
  Future<void> deleteCourse(String userId, String courseId) async {
    await _service.delete(path: 'students/$userId/courses/$courseId');
  }

  @override
  Future<CourseModel?> getCourseById(String userId, String courseId) async {
    final data = await _service.get<CourseModel>(
      path: 'students/$userId/courses/$courseId',
      builder: (data, docId) => CourseModel.fromFirestore(data, docId),
    );

    return data;
  }

  @override
  Future<List<CourseModel>> getCoursesByUserId(String userId) async {
    final data = await _service.getCollection<CourseModel>(
      path: 'students/$userId/courses/',
      builder: (data, docId) => CourseModel.fromFirestore(data, docId),
    );

    return data;
  }

  @override
  Future<void> updateCourse(String userId, CourseModel course) async {
    await _service.update(
      path: 'students/$userId/courses/${course.id}',
      data: course.toFirestore()
    );
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    throw UnimplementedError('Fetching all courses across all users requires a collectionGroup query.');
  }
}