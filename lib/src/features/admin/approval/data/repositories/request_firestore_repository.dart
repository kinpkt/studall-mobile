import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/firestore_service.dart';
import '../models/request_model.dart';

final requestFirestoreRepositoryProvider = Provider<RequestFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return RequestFirestoreRepository(firestoreService);
});

class RequestFirestoreRepository {
  final FirestoreService _service;

  RequestFirestoreRepository(this._service);

  Future<List<RequestModel>> getAllRequests() async {
    final data = await _service.getCollection<RequestModel>(
      path: 'requests/',
      builder: (data, docId) => RequestModel.fromFirestore(data, docId),
    );

    return data ?? [];
  }

  Future<void> updateRequest(String docId, RequestStatus newStatus) {
    return _service.update(
      path: 'requests/$docId',
      data: {
        'status': newStatus.name,
      }
    );
  }
}

