import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/auth_firebase_repository.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});

@riverpod
class AuthController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authFirebaseRepositoryProvider);

      final user = await authRepository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );

      final userRepository = ref.read(userFirestoreRepositoryProvider);
      await userRepository.createUserProfile(UserModel.fromFirebase(user));
    });
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authFirebaseRepositoryProvider);
      await authRepository.signInWithEmail(email: email, password: password);
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    try {
      final authRepository = ref.read(authFirebaseRepositoryProvider);
      final user = await authRepository.signInWithGoogle();

      // ทำงานขั้นตอนถัดไป
      final userRepository = ref.read(userFirestoreRepositoryProvider);
      await userRepository.createUserProfile(UserModel.fromFirebase(user));

      // สำเร็จ! เปลี่ยนสถานะเป็น Data (หยุด Loading)
      state = const AsyncData(null);
    } catch (e, stack) {
      // เกิด Error จริงๆ เปลี่ยนเป็น Error (หยุด Loading)
      state = AsyncError(e, stack);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 3));
      final authRepository = ref.read(authFirebaseRepositoryProvider);
      await authRepository.signOut();
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authFirebaseRepositoryProvider);
      await authRepository.sendPasswordResetEmail(email);
    });
  }
}
