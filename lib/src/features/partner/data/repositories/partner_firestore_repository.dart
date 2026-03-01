import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/core/services/firestore_service.dart';
import 'package:studall/src/features/partner/data/models/partner_model.dart';

final partnerFirestoreRepositoryProvider = Provider<PartnerFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return PartnerFirestoreRepository(firestoreService);
});

class PartnerFirestoreRepository {
  final FirestoreService _service;

  PartnerFirestoreRepository(this._service);

  Future<void> addPartner(PartnerModel partner) async {
    await _service.set(
      path: 'partners/${partner.id}',
      data: partner.toFirestore(),
    );
  }

  Stream<PartnerModel?> getPartnerByUserId(String userId) {
    return _service.streamDocument(
      path: 'partners/$userId',
      builder: (data, docId) => PartnerModel.fromFirestore(data, docId),
    );
  }

  Future<void> updatePartner(PartnerModel partner) async {
    await _service.update(
      path: 'partners/${partner.id}',
      data: partner.toFirestore(),
    );
  }

  Future<void> deletePartner(String partnerId) async {
    await _service.delete(path: 'partners/${partnerId}');
  }
}