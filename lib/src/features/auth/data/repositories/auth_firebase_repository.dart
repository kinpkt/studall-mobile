// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:studall/src/features/auth/domain/auth_exceptions.dart';

final authFirebaseRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthFirebaseRepository(FirebaseAuth.instance);
});

class AuthFirebaseRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthFirebaseRepository(this._firebaseAuth);

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) => user);
  }

  @override
  String? get currentUid => _firebaseAuth.currentUser?.uid;

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(username);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    final clientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
    if (clientId == null) throw Exception('GOOGLE_SERVER_CLIENT_ID missing');

    final List<String> scopes = ['email', 'profile'];

    try {
      await _googleSignIn.initialize(serverClientId: clientId);

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: await _getAccessToken(googleUser, scopes),
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('ไม่พบข้อมูลผู้ใช้');
      }

      return userCredential.user!;
    } on GoogleSignInException catch (e) {
      throw handleGoogleSignInException(e);
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการเข้าสู่ระบบ Google: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  Future<String?> _getAccessToken(
    GoogleSignInAccount googleUser,
    List<String> scopes,
  ) async {
    try {
      final GoogleSignInClientAuthorization? authStatus = await googleUser
          .authorizationClient
          .authorizationForScopes(scopes);

      if (authStatus != null) {
        return authStatus.accessToken;
      }

      final GoogleSignInClientAuthorization newAuth = await googleUser
          .authorizationClient
          .authorizeScopes(scopes);

      return newAuth.accessToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('คุณต้องอนุญาตสิทธิ์การเข้าถึงเพื่อใช้งานต่อ');
      }
      rethrow;
    }
  }
}
