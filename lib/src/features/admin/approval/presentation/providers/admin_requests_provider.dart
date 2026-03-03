import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/request_model.dart';
import '../../data/repositories/request_firestore_repository.dart';

final adminRequestsProvider = StreamProvider<List<RequestModel>>((ref) {
  final repository = ref.watch(requestFirestoreRepositoryProvider);
  return repository.getAllRequests();
});