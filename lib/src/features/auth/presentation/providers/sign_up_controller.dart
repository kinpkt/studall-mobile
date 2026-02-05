import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/firebase_auth_repository.dart';

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
      final authRepository = ref.read(authRepositoryProvider);

      await authRepository.signUpWithEmail(
          email: email,
          password: password
      );

      // await Future.delayed(const Duration(seconds: 2));

      // throw Exception("สร้างบัญชีไม่สำเร็จ");

      // await ref.read(authRepositoryProvider).signUpWithEmail(
      //   email: email,
      //   password: password,
      //   username: username,
      // );
    });
  }

  Future<void> googleSignUp() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);

      await authRepository.signInWithGoogle();

      // await Future.delayed(const Duration(seconds: 2));
      // TODO: เรียก Repository Google Sign Up
      // throw Exception("สร้างบัญชีไม่สำเร็จด้วย Google");
    });
  }
}
