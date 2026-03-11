import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/partner/data/models/partner_model.dart';

import '../../../../partner/advertisements/data/models/advertisement_model.dart';
import '../../../../partner/advertisements/data/repositories/advertisement_firestore_repository.dart';
import '../../../../partner/data/repositories/partner_firestore_repository.dart';
import '../../data/models/request_model.dart';
import '../../data/repositories/request_firestore_repository.dart';

final adminRequestsProvider = StreamProvider<List<RequestModel>>((ref) {
  final repository = ref.watch(requestFirestoreRepositoryProvider);
  return repository.getAllRequests();
});

final partnerStoreDataProvider = StreamProvider.family<PartnerModel?, String>((ref, String userId) {
  final repository = ref.watch(partnerFirestoreRepositoryProvider);
  final stream = repository.getPartnerByUserId(userId);

  return stream.map((partner) => partner);
});

final singleAdvertisementProvider = StreamProvider.family<AdvertisementModel?, String>((ref, adId) {
  final repository = ref.watch(advertisementFirestoreRepositoryProvider);

  return repository.getAdvertisementFromId(adId);
});