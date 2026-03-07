
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/core/services/firestore_service.dart';
import 'package:studall/src/features/student/data/models/student_model.dart';

final studentFirestoreRepositoryProvider = Provider<StudentFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return StudentFirestoreRepository(firestoreService);
});

final studentSettingsProvider = FutureProvider.family<StudentModel?, String>((ref, id) async {
  return ref.read(studentFirestoreRepositoryProvider).getStudentSettings(id);
});

class StudentFirestoreRepository {
  final FirestoreService _service;

  StudentFirestoreRepository(this._service);

  Future<StudentModel?> getStudentSettings(String id) async {
    final data = await _service.get(
      path: 'students/$id',
      builder: (data, docId) => StudentModel.fromFirestore(data, docId),
    );

    return data;
  }

  Future<void> updateSearchRadius(String id, double radius) async {
    await _service.update(
      path: 'students/$id',
      data: {'radius': radius},
    );
  }
}