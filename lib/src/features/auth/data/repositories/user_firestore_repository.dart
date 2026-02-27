import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firestore_service.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

final userFirestoreRepositoryProvider = Provider<UserRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return UserFirestoreRepository(firestoreService);
});

class UserFirestoreRepository implements UserRepository {
  final FirestoreService _service;

  UserFirestoreRepository(this._service);

  @override
  Future<void> createUserProfile(UserModel user) async {
    await _service.exists(path: 'users/${user.id}').then((exists) {
      if (!exists) {
        _service.set(path: 'users/${user.id}', data: user.toFirestore());
      }
    });
  }

  @override
  Future<UserModel?> getUserProfile(String id) async {
    final data = await _service.get(
      path: 'users/$id',
      builder: (data, id) => UserModel.fromFirestore(data, id),
    );
    if (data != null) return data;
    return null;
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await _service.update(path: 'users/${user.id}', data: user.toFirestore());
  }

  @override
  Stream<UserModel?> streamUserProfile(String id) {
    return _service.streamDocument(
      path: 'users/$id',
      builder: (data, id) {
        final user = UserModel.fromFirestore(data, id);
        user.debugPrint();
        return user;
      },
    );
  }

  @override
  Future<bool> checkUserExists(String id) async {
    final bool isExists = await _service.exists(path: 'users/$id');
    return isExists;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final data = await _service.getCollection<UserModel>(
      path: 'users/',
      builder: (data, docId) => UserModel.fromFirestore(data, docId),
    );

    return data;
  }

  @override
  Future<void> updateUserBanStatus(String uid, bool isBanned) async {
    await _service.update(
      path: 'users/$uid',
      data: {
        'isBanned': isBanned,
      }
    );
  }
}
