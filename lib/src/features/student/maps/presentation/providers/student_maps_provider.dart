import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../../partner/branches/data/models/branch_model.dart';
import '../../../../partner/branches/data/repositories/branch_firestore_repository.dart';

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

    if (distance <= args.radius) {
      filteredBranches.add(branch);
    }
  }

  return filteredBranches;
});