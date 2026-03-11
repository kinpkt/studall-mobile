import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../partner/branches/data/models/branch_model.dart';
import '../../../../partner/branches/data/repositories/branch_firestore_repository.dart';
import '../../../data/repositories/student_firestore_repository.dart';

final nearbyBranchesProvider = FutureProvider.family<List<BranchModel>, ({LatLng center, int radius})>((ref, args) async {
  final repository = ref.watch(branchFirestoreRepositoryProvider);
  final allBranches = await repository.getAllBranches();

  List<BranchModel> filteredBranches = [];

  for (final branch in allBranches) {
    final distance = Geolocator.distanceBetween(
      args.center.latitude,
      args.center.longitude,
      branch.location.latitude,
      branch.location.longitude,
    );

    if (distance <= args.radius && branch.partnerIsPermitted) {
      filteredBranches.add(branch);
    }
  }

  return filteredBranches;
});

final studentRadiusProvider = FutureProvider<double>((ref) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId == null)
    return 2000.0;

  final repository = ref.read(studentFirestoreRepositoryProvider);
  final settings = await repository.getStudentSettings(userId);

  return settings?.radius ?? 2000.0;
});