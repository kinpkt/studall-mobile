import 'package:studall/src/features/auth/data/models/user_model.dart';
import 'package:uuid/uuid.dart';

enum RequestType {
  store, // ขอเพิ่มร้านใหม่เข้าสู่ระบบ
  advertise, // ขอเพิ่มโฆษณา (ให้แอดมินตรวจสอบเนื้อหาก่อน)
  others, // อื่น ๆ (กรณีเป็นคำขอเรื่องอื่น)
}

enum RequestStatus {
  pending,
  approved,
  declined,
}

class RequestModel {
  final String id;
  final String requestedUserId;
  final RequestType type;
  final RequestStatus status;
  String? description;
  String? reason;

  static const _uuid = Uuid();

  RequestModel({
    String? id,
    required this.type,
    required this.requestedUserId,
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

  factory RequestModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final String? requestTypeString = data['type'] as String?;
    final String? requestStatusString = data['status'] as String?;

    final RequestType parsedType = RequestType.values.firstWhere(
      (e) => e.name == requestTypeString,
      orElse: () => RequestType.others,
    );

    final RequestStatus parsedStatus = RequestStatus.values.firstWhere(
      (e) => e.name == requestStatusString,
      orElse: () => RequestStatus.pending,
    );

    return RequestModel(
      id: docId,
      type: parsedType,
      status: parsedStatus,
      requestedUserId: data['requestedUserId']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'requestedUserId': requestedUserId,
      'type': type.name,
      'status': status.name,
      if (description != null)
        'description': description,
      if (reason != null)
        'reason': reason,
    };
  }
}