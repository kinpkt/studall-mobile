import 'package:firebase_auth/firebase_auth.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';
import 'package:studall/src/features/auth/data/repositories/auth_repository.dart';
import 'package:studall/src/core/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authFirestoreRepositoryProvider = Provider<AuthFirestoreRepository>((
  ref,
) {
  return FirestoreAuthRepository(FirestoreService());
});

class FirestoreAuthRepository implements AuthFirestoreRepository {
  final FirestoreService _firestoreService;

  FirestoreAuthRepository(this._firestoreService);



  @override
  Future<void> createUserProfile(user) async {
    
    await _firestoreService.set(
      path: 'users/${user.uid}',
      data: <String, dynamic>{
        'uid': user.uid,
        'email': user.email,
        'username': user.displayName,
        'photoUrl': user.photoURL ?? '',
        'createdAt': DateTime.now(),
      },
    );
  }
}
