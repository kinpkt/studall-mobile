import 'package:studall/src/features/auth/data/models/user_model.dart';

abstract class UserRepository {
  /// สร้างข้อมูลผู้ใช้ใหม่ลง Firestore
  Future<void> createUserProfile(UserModel user);

  /// ดึงข้อมูลผู้ใช้จาก UID
  Future<UserModel?> getUserProfile(String uid);

  /// แก้ไขข้อมูลผู้ใช้
  Future<void> updateUserProfile(UserModel user);

  /// Stream ข้อมูลผู้ใช้แบบ Real-time
  Stream<UserModel?> streamUserProfile(String uid);

  Future<bool> checkUserExists(String uid);

  /// ดึงข้อมูลผู้ใช้ทั้งหมด
  Future<List<UserModel>> getAllUsers();

  /// อัปเดทข้อมูลสถานะการแบนของผู้ใช้
  Future<void> updateUserBanStatus(String uid, bool isBanned);
}
