import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

final userProfileProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref
          .watch(userFirestoreRepositoryProvider)
          .streamUserProfile(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, _) => const Stream.empty(),
  );
});
