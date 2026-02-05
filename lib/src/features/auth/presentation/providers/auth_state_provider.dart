import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/models/user_model.dart';

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return authRepository.authStateChanges();
});

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../data/models/user_model.dart';
// import '../../data/repositories/auth_repository.dart';
// import '../../data/repositories/auth_repository_impl.dart';

// /// Provider for AuthRepository
// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   return AuthRepositoryImpl();
// });

// /// Stream provider for authentication state changes
// final authStateProvider = StreamProvider<UserModel?>((ref) {
//   final authRepository = ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// });

// /// Provider to check if user is authenticated
// final isAuthenticatedProvider = Provider<bool>((ref) {
//   final authState = ref.watch(authStateProvider);
//   return authState.maybeWhen(data: (user) => user != null, orElse: () => false);
// });

// /// Provider to get current user
// final currentUserProvider = Provider<UserModel?>((ref) {
//   final authState = ref.watch(authStateProvider);
//   return authState.maybeWhen(data: (user) => user, orElse: () => null);
// });
