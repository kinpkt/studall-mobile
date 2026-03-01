import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

enum BranchStatus {
  available,
  moderate,
  busy,
}

extension BranchStatusExtension on BranchStatus {
  String get thaiStatus {
    switch (this) {
      case BranchStatus.available:
        return 'ไม่ค่อยยุ่ง';
      case BranchStatus.moderate:
        return 'ยุ่งปานกลาง';
      case BranchStatus.busy:
        return 'ยุ่งมาก';
    }
  }

  Color getColor(ShadThemeData theme) {
    switch (this) {
      case BranchStatus.available:
        return theme.colorScheme.custom['green'] ?? Colors.green;
      case BranchStatus.moderate:
        return theme.colorScheme.custom['warning'] ?? Colors.orange;
      case BranchStatus.busy:
        return theme.colorScheme.destructive;
    }
  }
}

class BranchModel {
  final String id;
  final String name;
  final GeoPoint location;
  final BranchStatus status;

  BranchModel({
    String? id,
    required this.name,
    required this.location,
    this.status = BranchStatus.available,
  }) : id = id ?? const Uuid().v7();

  LatLng get leafletCoordinate => LatLng(location.latitude, location.longitude);

  factory BranchModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return BranchModel(
      id: docId,
      name: data['name'] as String,
      location: data['location'] as GeoPoint,
      status: BranchStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'available'),
        orElse: () => BranchStatus.available,
      ),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'status': status.name,
    };
  }
}