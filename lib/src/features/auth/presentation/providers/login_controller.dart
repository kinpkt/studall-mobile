import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/firebase_auth_repository.dart';

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
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithEmail(email: email, password: password);

      // await Future.delayed(const Duration(seconds: 2));

      // throw Exception("เข้าสู่ระบบไม่สำเร็จ");

      // await ref.read(authRepositoryProvider).signInWithEmail(email, password);
    });
  }

  Future<void> googleLogin() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authRepositoryProvider);
      await authRepository.signInWithGoogle();
    });
  }
}
