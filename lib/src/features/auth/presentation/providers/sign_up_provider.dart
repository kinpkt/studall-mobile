import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studall/src/features/auth/data/repositories/firestore_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

final signUpControllerProvider = AsyncNotifierProvider<SignUpController, void>(
  () {
    return SignUpController();
  },
);

class SignUpController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signUp(String email, String password, String username) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
     final authRepository = ref.read(authFirebaseRepositoryProvider);

      User user = await authRepository.signUpWithEmail(
          email: email,
          password: password,
          username: username
      );

      final firestoreRepository = ref.read(authFirestoreRepositoryProvider);
      await firestoreRepository.createUserProfile(user);
    });
  }
}
