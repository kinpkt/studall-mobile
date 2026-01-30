import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      await Future.delayed(const Duration(seconds: 2));

      throw Exception("เข้าสู่ระบบไม่สำเร็จ");

      // TODO: เรียก Repository ตรงนี้
      // await ref.read(authRepositoryProvider).signInWithEmail(email, password);
    });
  }

  Future<void> googleLogin() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 2));
      // TODO: เรียก Repository Google Sign In
      throw Exception("เข้าสู่ระบบไม่สำเร็จด้วย Google");
    });
  }
}
