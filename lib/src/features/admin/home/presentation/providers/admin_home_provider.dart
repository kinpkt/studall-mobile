import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/admin/approval/data/models/request_model.dart';
import 'package:studall/src/features/admin/approval/data/repositories/request_firestore_repository.dart';

import '../../../../auth/data/models/role.dart';
import '../../../../auth/data/repositories/user_firestore_repository.dart';

final studentCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(userFirestoreRepositoryProvider);
  return repository.getUsersCountByRole(Role.student);
});

final partnerCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(userFirestoreRepositoryProvider);
  return repository.getUsersCountByRole(Role.partner);
});

final advertisementRequestCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(requestFirestoreRepositoryProvider);
  return repository.getRequestsCountByStatusAndType(RequestStatus.pending, RequestType.advertise);
});

final partnerRequestCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(requestFirestoreRepositoryProvider);
  return repository.getRequestsCountByStatusAndType(RequestStatus.pending, RequestType.store);
});