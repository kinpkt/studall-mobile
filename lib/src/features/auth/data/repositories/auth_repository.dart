import '../models/user_model.dart';

/// Authentication Repository Interface
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Get current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Sign in with email and password
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Sign out
  Future<void> signOut();

  /// Stream of authentication state changes
  Stream<UserModel?> authStateChanges();
}
