import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/auth_firebase_repository.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

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
      final user = await authRepository.signInWithGoogle();

      final userRepository = ref.read(userFirestoreRepositoryProvider);
      await userRepository.createUserProfile(UserModel.fromFirebase(user));
    });
  }
}
