import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authFirebaseRepositoryProvider);

  return authRepository.authStateChanges;
});

