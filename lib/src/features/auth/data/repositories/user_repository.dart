import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/auth/data/models/user_model.dart';

abstract class UserRepository {
  /// สร้างข้อมูลผู้ใช้ใหม่ลง Firestore
  Future<void> createUserProfile(UserModel user);

  /// ดึงข้อมูลผู้ใช้จาก UID
  Future<UserModel?> getUserProfile(String id);

  /// แก้ไขข้อมูลผู้ใช้
  Future<void> updateUserProfile(UserModel user);

  /// Stream ข้อมูลผู้ใช้แบบ Real-time
  Stream<UserModel?> streamUserProfile(String id);

  Future<bool> checkUserExists(String id);

  /// ดึงข้อมูลผู้ใช้ทั้งหมด
  Future<List<UserModel>> getAllUsers();

  /// นับจำนวนผู้ใช้ทั้งหมดในระบบ
  Future<int> getAllUsersCount();

  /// นับจำนวนผู้ใช้ทั้งหมดที่มียศ
  Future<int> getUsersCountByRole(Role role);

  Future<void> addUserRole(String uid, Role role);

  /// อัปเดทข้อมูลสถานะการแบนของผู้ใช้
  Future<void> updateUserBanStatus(String uid, bool isBanned);

  Future<void> updateUserLastActiveRole(String uid, Role role);
}
