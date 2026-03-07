import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/auth_firebase_repository.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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

      await authRepository
          .signUpWithEmail(
            email: email,
            password: password,
            displayName: displayName,
          )
          .then((user) async {
            final userRepository = ref.read(userFirestoreRepositoryProvider);
            await userRepository.createUserProfile(
              UserModel.fromFirebase(user),
            );
            return user;
          });
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

  Future<void> signOut(BuildContext context) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final authRepository = ref.read(authFirebaseRepositoryProvider);
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadDialog.alert(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
            ),
            actions: [
              ShadButton.secondary(
                onPressed: () => ctx.pop(),
                child: const Text('ยกเลิก'),
              ),
              ShadButton.destructive(
                onPressed: () async {
                  await authRepository.signOut();
                  if (!ctx.mounted) return;
                  ctx.pop();
                },
                child: Consumer(
                  builder: (context, ref, child) {
                    return state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('ออกจากระบบ');
                  },
                ),
              ),
            ],
          ),
        ),
      );
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
