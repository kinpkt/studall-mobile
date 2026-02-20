import 'package:studall/src/features/auth/data/models/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v7.dart';

enum RequestType {
  store, // ขอเพิ่มร้านใหม่เข้าสู่ระบบ
  advertise, // ขอเพิ่มโฆษณา (ให้แอดมินตรวจสอบเนื้อหาก่อน)
}

enum RequestStatus {
  pending,
  approved,
  declined,
}

class RequestModel {
  final String id;
  final UserModel requestedUser;
  final RequestType type;
  final RequestStatus status;
  String? reason;

  static const _uuid = Uuid();

  RequestModel({
    String? id,
    required this.type,
    required this.requestedUser,
    this.status = RequestStatus.pending,
  }) : id = id ?? _uuid.v7();

  String get thaiTypeEnumValue {
    switch (type) {
      case (RequestType.advertise):
        return 'คำขอเพิ่มโฆษณาใหม่';
      case (RequestType.store):
        return 'คำขอใช้งานบัญชีร้านค้า';
      default:
        return '';
    }
  }
}