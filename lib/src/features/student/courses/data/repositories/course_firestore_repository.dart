
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
  Future<void> addCourse(CourseModel course) async {
    await _service.add(
      collectionPath: 'courses',
      data: course.toFirestore()
    );
  }

  @override
  Future<void> deleteCourse(String id) async {
    await _service.delete(path: 'courses/$id');
  }

  @override
  Future<CourseModel?> getCourseById(String id) async {
    final data = await _service.get<CourseModel>(
      path: 'courses/$id',
      builder: (data, docId) => CourseModel.fromFirestore(data, docId),
    );

    return data;
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    final data = await _service.getCollection<CourseModel>(
      path: 'courses/',
      builder: (data, docId) => CourseModel.fromFirestore(data, docId),
    );

    return data ?? [];
  }

  @override
  Future<List<CourseModel>> getCoursesByUserId(String userId) async {
    final data = await _service.getCollection<CourseModel>(
      path: 'courses/',
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
      builder: (data, docId) => CourseModel.fromFirestore(data, docId),
    );

    return data ?? [];
  }

  @override
  Future<void> updateCourse(CourseModel course) async {
    await _service.update(
      path: 'courses/${course.id}',
      data: course.toFirestore()
    );
  }
}