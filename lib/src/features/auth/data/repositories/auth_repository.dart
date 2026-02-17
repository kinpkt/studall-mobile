import 'package:firebase_auth/firebase_auth.dart';

/// Authentication Repository Interface
abstract class AuthFirebaseRepository {
  /// สตรีมสถานะการล็อกอิน
  Stream<User?> get authStateChanges;

  /// ดึง UID ของผู้ใช้ปัจจุบัน
  String? get currentUid;

  /// สมัครสมาชิก
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  });

  /// ล็อกอินด้วย Email
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });

  /// ล็อกอินด้วย Google
  Future<User> signInWithGoogle();

  /// ออกจากระบบ
  Future<void> signOut();

  /// ส่งอีเมลรีเซ็ตรหัสผ่าน
  Future<void> sendPasswordResetEmail(String email);
}

abstract class AuthFirestoreRepository {
  /// สร้างโปรไฟล์ผู้ใช้ใน Firestore
  Future<void> createUserProfile(User user);
}
