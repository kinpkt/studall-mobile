import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  FirebaseAuthRepository(this._firebaseAuth, this._firestore);

  UserModel? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      photoUrl: user.photoURL ?? '',
      username: user.displayName ?? '',
      fullName: user.displayName ?? '',
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
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user!)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
          await user.reload();
        }
        // สร้าง User Doc แบบ Hub & Spoke
        await _syncUserDocIfNeeded(user, displayName: displayName);
      }

      return _userFromFirebase(_firebaseAuth.currentUser)!;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
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

  Future<void> _initGoogleSignIn() async {
    final clientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
    if (clientId == null) {
      print("Error: GOOGLE_SERVER_CLIENT_ID not found in .env");
      return;
    }
    await _googleSignIn.initialize(serverClientId: clientId);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final clientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
    if (clientId == null) {
      // ignore: avoid_print
      print("Error: GOOGLE_SERVER_CLIENT_ID not found in .env");
      return Future.error('การตั้งค่า Google Sign-In ไม่ถูกต้อง');
    }

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

      // Sign in to Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) {
        throw Exception('Firebase Sign In failed');
      }

      // await _syncUserDocIfNeeded(user);

      return _userFromFirebase(user)!;
    } on GoogleSignInException catch (e) {
      throw _handleGoogleSignInException(e);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดในการเข้าสู่ระบบ Google: $e');
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

  Exception _handleGoogleSignInException(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.canceled:
        return Exception('ยกเลิกการเข้าสู่ระบบ');
      case GoogleSignInExceptionCode.interrupted:
        return Exception('การเข้าสู่ระบบถูกขัดจังหวะ กรุณาลองใหม่อีกครั้ง');
      case GoogleSignInExceptionCode.clientConfigurationError:
        return Exception('ตั้งค่า Google Sign-In ไม่ถูกต้อง: ${e.description}');
      case GoogleSignInExceptionCode.providerConfigurationError:
        return Exception('ระบบ Auth ไม่พร้อมใช้งาน กรุณาลองใหม่ภายหลัง');
      case GoogleSignInExceptionCode.uiUnavailable:
        return Exception('ไม่สามารถแสดงหน้าจอเข้าสู่ระบบได้');
      case GoogleSignInExceptionCode.userMismatch:
        return Exception('ผู้ใช้งานไม่ตรงกัน กรุณาลองใหม่อีกครั้ง');
      case GoogleSignInExceptionCode.unknownError:
        return Exception('เกิดข้อผิดพลาดไม่ทราบสาเหตุในการเข้าสู่ระบบ');
    }
  }

  // ------------------------------------------------------------------
  // 💾 Internal Helpers
  // ------------------------------------------------------------------

  Future<void> _syncUserDocIfNeeded(User user, {String? displayName}) async {
    final userDoc = _firestore.collection('users').doc(user.uid);
    final docSnapshot = await userDoc.get();

    // ถ้ายังไม่มี Doc ให้สร้างใหม่แบบ "ตัวเปล่า" (Blank User)
    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'displayName': displayName ?? user.displayName,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'roles': [],
        'lastActiveRole': null,
      });
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('ไม่พบผู้ใช้งานนี้ในระบบ');
      case 'wrong-password':
        return Exception('รหัสผ่านไม่ถูกต้อง');
      case 'email-already-in-use':
        return Exception('อีเมลนี้ถูกใช้งานแล้ว');
      case 'weak-password':
        return Exception('รหัสผ่านคาดเดาง่ายเกินไป');
      case 'account-exists-with-different-credential':
        return Exception('มีบัญชีนี้อยู่แล้วด้วยวิธีล็อกอินอื่น');
      default:
        return Exception('เกิดข้อผิดพลาด: ${e.message}');
    }
  }
}
