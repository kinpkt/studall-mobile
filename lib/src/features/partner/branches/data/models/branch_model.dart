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
  final String partnerName;
  final String partnerDescription;
  final bool partnerIsPermitted;
  final String name;
  final GeoPoint location;
  final BranchStatus status;

  BranchModel({
    String? id,
    required this.partnerName,
    required this.partnerDescription,
    partnerIsPermitted,
    required this.name,
    required this.location,
    this.status = BranchStatus.available,
  }) :  id = id ?? const Uuid().v7(),
        partnerIsPermitted = partnerIsPermitted ?? false;

  LatLng get leafletCoordinate => LatLng(location.latitude, location.longitude);

  BranchModel copyWith({
    String? id,
    String? partnerName,
    String? partnerDescription,
    bool? partnerIsPermitted,
    String? name,
    GeoPoint? location,
    BranchStatus? status,
  }) {
    return BranchModel(
      id: id ?? this.id,
      partnerName: partnerName ?? this.partnerName,
      partnerDescription: partnerDescription ?? this.partnerDescription,
      partnerIsPermitted: partnerIsPermitted ?? this.partnerIsPermitted,
      name: name ?? this.name,
      location: location ?? this.location,
      status: status ?? this.status,
    );
  }

  factory BranchModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return BranchModel(
      id: docId,
      partnerName: data['partnerName'] as String,
      partnerDescription: data['partnerDescription'] as String,
      partnerIsPermitted: data['partnerIsPermitted'] as bool?,
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
      'partnerName': partnerName,
      'partnerDescription': partnerDescription,
      'partnerIsPermitted': partnerIsPermitted,
      'name': name,
      'location': location,
      'status': status.name,
    };
  }
}