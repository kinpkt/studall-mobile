import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firestore_service.dart';
import '../../../data/models/utility_model.dart';

final utilityFirestoreRepositoryProvider = Provider<UtlityFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UtlityFirestoreRepository(firestoreService);
});

class UtlityFirestoreRepository {
  final FirestoreService _service;

  UtlityFirestoreRepository(this._service);

  Future<void> addUtility(UtilityModel request) async {
    await _service.add(
        collectionPath: 'utilities',
        data: request.toFirestore()
    );
  }

  Future<List<UtilityModel>> getUtilitiesByUserId(String userId) async {
    final data = await _service.getCollection<UtilityModel>(
      path: 'utilities/',
      builder: (data, docId) => UtilityModel.fromFirestore(data, docId),
    );

    return data;
  }
}