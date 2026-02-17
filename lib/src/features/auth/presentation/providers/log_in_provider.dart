import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:studall/src/features/auth/data/repositories/firestore_auth_repository.dart';


final loginControllerProvider = AsyncNotifierProvider<LoginController, void>(
  () {
    return LoginController();
  },
);

class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authFirebaseRepositoryProvider);
      await authRepository.signInWithEmail(email: email, password: password);
    });
  }

  Future<void> googleLogin() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authFirebaseRepositoryProvider);
      User user = await authRepository.signInWithGoogle();
      
      final authFirestoreRepository = ref.read(authFirestoreRepositoryProvider);
      await authFirestoreRepository.createUserProfile(user);
    });
  }
}
