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

  Future<void> addRequest(RequestModel request) async {
    await _service.set(
      path: 'requests/${request.id}',
      data: request.toFirestore()
    );
  }

  Future<List<RequestModel>> getAllRequests() async {
    final data = await _service.getCollection<RequestModel>(
      path: 'requests/',
      builder: (data, docId) => RequestModel.fromFirestore(data, docId),
    );

    return data ?? [];
  }

  Future<List<RequestModel>> getRequestsByUserId(String userId) async {
    final data = await _service.getCollection<RequestModel>(
      path: 'requests/',
      queryBuilder: (query) => query.where('requestedUserId', isEqualTo: userId),
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

