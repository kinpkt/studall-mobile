import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

final userProfileProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);

      final repo = ref.watch(userFirestoreRepositoryProvider);

      return repo
          .streamUserProfile(user.uid)
          .handleError((error, stackTrace) {
            // Log and emit null so the UI doesn't break
            print('[userProfileProvider] stream error: $error');
            return null;
          })
          .asyncMap((profile) async {
            if (profile != null) return profile;

            // Profile missing in Firestore – try to recreate it
            try {
              final newProfile = UserModel.fromFirebase(user);
              await repo.createUserProfile(newProfile);
              // Return the freshly created profile
              return await repo.getUserProfile(user.uid);
            } catch (e) {
              print('[userProfileProvider] failed to recreate profile: $e');
              return null;
            }
          });
    },
    loading: () => const Stream.empty(),
    error: (_, __) => Stream.value(null),
  );
});
