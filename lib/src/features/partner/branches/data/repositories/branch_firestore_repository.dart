import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/firestore_service.dart';
import '../models/branch_model.dart';

final branchFirestoreRepositoryProvider = Provider<BranchFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return BranchFirestoreRepository(firestoreService);
});

class BranchFirestoreRepository {
  final FirestoreService _service;

  BranchFirestoreRepository(this._service);

  Future<void> addBranch(String userId, BranchModel branch) async {
    await _service.set(
      path: 'partners/$userId/branches/${branch.id}',
      data: branch.toFirestore(),
    );
  }

  Stream<BranchModel?> getBranchById(String userId, String id) {
    return _service.streamDocument(
      path: 'partners/$userId/branches/$id',
      builder: (data, docId) => BranchModel.fromFirestore(data, docId),
    );
  }

  Stream<List<BranchModel>> getBranchesByUserId(String userId) {
    return _service.streamCollection(
      path: 'partners/$userId/branches',
      builder: (data, docId) => BranchModel.fromFirestore(data, docId),
    );
  }

  Future<void> updateBranch(String userId, BranchModel branch) async {
    await _service.update(
      path: 'partners/$userId/branches/${branch.id}',
      data: branch.toFirestore(),
    );
  }

  Future<void> deleteBranch(String userId, BranchModel branch) async {
    await _service.delete(path: 'partners/$userId/${branch.id}');
  }
}