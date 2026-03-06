import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:uuid/uuid.dart';

enum RequestType {
  store, // ขอเพิ่มร้านใหม่เข้าสู่ระบบ
  advertise, // ขอเพิ่มโฆษณา (ให้แอดมินตรวจสอบเนื้อหาก่อน)
}

extension RequestTypeExtension on RequestType {
  String get thaiType {
    switch (this) {
      case (RequestType.advertise):
        return 'คำขอเพิ่มโฆษณาใหม่';
      case (RequestType.store):
        return 'คำขอใช้งานบัญชีร้านค้า';
    }
  }
}

enum RequestStatus {
  pending,
  approved,
  declined,
}

extension RequestStatusExtension on RequestStatus {
  String get thaiStatus {
    switch (this) {
      case (RequestStatus.pending):
        return 'รอดำเนินการ';
      case (RequestStatus.approved):
        return 'อนุมัติแล้ว';
      case (RequestStatus.declined):
        return 'ปฏิเสธ';
    }
  }

  Color getColor(ShadThemeData theme) {
    switch (this) {
      case RequestStatus.approved:
        return theme.colorScheme.custom['green'] ?? Colors.green;
      case RequestStatus.pending:
        return theme.colorScheme.custom['warning'] ?? Colors.orange;
      case RequestStatus.declined:
        return theme.colorScheme.destructive;
    }
  }
}

class RequestModel {
  final String id;
  final String requestedUserId;
  final RequestType type;
  final RequestStatus status;
  String? description;
  String? reason;
  DateTime createdAt;
  DateTime updatedAt;

  static const _uuid = Uuid();

  RequestModel({
    String? id,
    required this.type,
    required this.requestedUserId,
    this.status = RequestStatus.pending,
    createdAt,
    updatedAt,
  }) :  id = id ?? _uuid.v7(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory RequestModel.fromFirestore(Map<String, dynamic> data, String docId) {
    final String? requestTypeString = data['type'] as String?;
    final String? requestStatusString = data['status'] as String?;

    final RequestType parsedType = RequestType.values.firstWhere(
      (e) => e.name == requestTypeString,
      orElse: () => RequestType.store,
    );

    final RequestStatus parsedStatus = RequestStatus.values.firstWhere(
      (e) => e.name == requestStatusString,
      orElse: () => RequestStatus.pending,
    );

    return RequestModel(
      id: data['id'],
      type: parsedType,
      status: parsedStatus,
      requestedUserId: data['requestedUserId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}