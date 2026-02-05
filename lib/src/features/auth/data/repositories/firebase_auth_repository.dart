import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(FirebaseAuth.instance);
});

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  UserModel? _userFromFirebase(User? user) {
    if (user == null)
      return null;
    
    return UserModel(
        id: user.uid,
        email: user.email ?? '',
        username: user.displayName ?? '',
        // fullName: fullName
    );
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  @override
  Future<UserModel> signInWithEmail({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

    if (credential.user == null)
      throw Exception('Sign in failed');

    return _userFromFirebase(credential.user!)!;
  }

  @override
  Future<UserModel> signUpWithEmail({required String email, required String password, String? displayName}) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

    if (credential.user != null && displayName != null) {
      await credential.user!.updateDisplayName(displayName);
      await credential.user!.reload();
    }
    
    return _userFromFirebase(_firebaseAuth.currentUser)!;
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<UserModel> signInWithGoogle() {
    throw UnimplementedError();
  }
}