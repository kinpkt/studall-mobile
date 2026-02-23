import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

enum BranchStatus {
  available,
  moderate,
  busy,
}

class BranchModel {
  final String id;
  final String name;
  final BranchStatus status;
  final GeoPoint location;

  static const _uuid = Uuid();

  BranchModel({
    String? id,
    required this.name,
    this.status = BranchStatus.available,
    required this.location,
  }) : id = id ?? _uuid.v7();

  LatLng get leafletCoordinate => LatLng(location.latitude, location.longitude);
}