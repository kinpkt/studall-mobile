import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../admin/approval/data/models/request_model.dart';
import '../../../../admin/approval/data/repositories/request_firestore_repository.dart';
import '../../../advertisements/data/models/advertisement_model.dart';
import '../../../advertisements/data/repositories/advertisement_firestore_repository.dart';
import '../../../branches/data/models/branch_model.dart';
import '../../../branches/data/repositories/branch_firestore_repository.dart';
import '../../../data/models/partner_model.dart';
import '../../../data/repositories/partner_firestore_repository.dart';

final partnerProvider = StreamProvider<PartnerModel?>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value(null);

  final repository = ref.watch(partnerFirestoreRepositoryProvider);
  return repository.getPartnerByUserId(currentUser.uid);
});

final branchesProvider = StreamProvider<List<BranchModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value([]);

  final repository = ref.watch(branchFirestoreRepositoryProvider);
  return repository.getBranchesByUserId(currentUser.uid);
});

final advertisementsProvider = StreamProvider<List<AdvertisementModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value([]);

  final repository = ref.watch(advertisementFirestoreRepositoryProvider);
  return repository.getAdvertisementsFromUserId(currentUser.uid);
});

final requestsProvider = StreamProvider<List<RequestModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null)
    return Stream.value([]);

  final repository = ref.watch(requestFirestoreRepositoryProvider);

  return repository.getRequestsByUserId(currentUser.uid);
});