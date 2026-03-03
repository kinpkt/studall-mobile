import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/branch_model.dart';
import '../../data/repositories/branch_firestore_repository.dart';

final partnerBranchesProvider = StreamProvider<List<BranchModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return Stream.value([]);
  }

  final repository = ref.watch(branchFirestoreRepositoryProvider);
  return repository.getBranchesByUserId(currentUser.uid);
});