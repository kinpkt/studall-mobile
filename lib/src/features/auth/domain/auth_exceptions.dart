// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

extension ExceptionExtension on Object {
  String get message {
    if (this is Exception) {
      return toString().replaceAll('Exception: ', '');
    }
    return toString();
  }
}

Exception handleGoogleSignInException(GoogleSignInException e) {
  print('Google Sign-In error: ${e.code}, description: ${e.description}');
  switch (e.code) {
    case GoogleSignInExceptionCode.canceled:
      return Exception('การเข้าสู่ระบบด้วย Google ถูกยกเลิก');
    case GoogleSignInExceptionCode.interrupted:
      return Exception('การเข้าสู่ระบบถูกหยุดระหว่างดำเนินการ');
    case GoogleSignInExceptionCode.clientConfigurationError:
      return Exception('การตั้งค่า Google Sign-In ไม่ถูกต้อง');
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

Exception handleAuthException(FirebaseAuthException e) {
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
