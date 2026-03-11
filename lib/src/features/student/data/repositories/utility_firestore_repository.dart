import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/core/services/firestore_service.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';

final utilityFirestoreRepositoryProvider = Provider<UtilityFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UtilityFirestoreRepository(firestoreService);
});

class UtilityFirestoreRepository {
  final FirestoreService _service;

  UtilityFirestoreRepository(this._service);

  Future<void> addUtility(String userId, UtilityModel utility) async {
    await _service.set(
      path: 'students/$userId/utilities/${utility.id}',
      data: utility.toFirestore(),
    );
  }

  Stream<List<UtilityModel>> getUtilitiesByUserId(String userId) {
    final data = _service.streamCollection(
      path: 'students/$userId/utilities',
      queryBuilder: (query) => query.orderBy('createdAt', descending: true),
      builder: (data, docId) => UtilityModel.fromFirestore(data, docId),
    );

    return data;
  }
  
  Future<List<UtilityModel>> getUtilitiesByUserIdAndCourseId(String userId, String courseId) async {
    final data = await _service.getCollection(
      path: 'students/$userId/utilities',
      queryBuilder: (query) => query.where('courseId', isEqualTo: courseId).orderBy('createdAt', descending: true),
      builder: (data, docId) => UtilityModel.fromFirestore(data, docId),
    );
    
    return data;
  }

  Future<void> updateUtility(String userId, UtilityModel utility) async {
    await _service.update(
      path: 'students/$userId/utilities/${utility.id}',
      data: utility.toFirestore(),
    );
  }

  Future<void> deleteUtility(String userId, String utilityId) async {
    await _service.delete(path: 'students/$userId/utilities/$utilityId');
  }

  Future<void> deleteUtilitiesByCourseId(String userId, String courseId) async {
    final utilities = await _service.getCollection<UtilityModel>(
      path: 'students/$userId/utilities',
      builder: (data, docId) => UtilityModel.fromFirestore(data, docId),
      queryBuilder: (query) => query.where('courseId', isEqualTo: courseId),
    );
    for (final utility in utilities) {
      await _service.delete(path: 'students/$userId/utilities/${utility.id}');
    }
  }
}