import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/firestore_service.dart';
import '../models/advertisement_model.dart';

final advertisementFirestoreRepositoryProvider = Provider<AdvertisementFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return AdvertisementFirestoreRepository(firestoreService);
});

class AdvertisementFirestoreRepository {
  final FirestoreService _service;

  AdvertisementFirestoreRepository(this._service);

  Future<void> addAdvertisement(AdvertisementModel ads) async {
    await _service.set(
      path: 'advertisements/${ads.id}',
      data: ads.toFirestore(),
    );
  }

  Stream<List<AdvertisementModel>> getAllAdvertisements() {
    return _service.streamCollection(
      path: 'advertisements/',
      builder: (data, docId) => AdvertisementModel.fromFirestore(data, docId),
    );
  }

  Stream<List<AdvertisementModel>> getAllPublishedAdvertisements() {
    return _service.streamCollection(
      path: 'advertisements/',
      queryBuilder: (query) => query.where('isPublished', isEqualTo: true).orderBy('createdAt', descending: true),
      builder: (data, docId) => AdvertisementModel.fromFirestore(data, docId),
    );
  }

  Stream<List<AdvertisementModel>> getAdvertisementsFromUserId(String userId)  {
    return _service.streamCollection(
      path: 'advertisements/',
      queryBuilder: (query) => query.where('userId', isEqualTo: userId).orderBy('createdAt', descending: true),
      builder: (data, docId) => AdvertisementModel.fromFirestore(data, docId),
    );
  }

  Stream<AdvertisementModel?> getAdvertisementFromId(String id) {
    return _service.streamDocument(
      path: 'advertisements/$id',
      builder: (data, docId) => AdvertisementModel.fromFirestore(data, docId),
    );
  }

  Future<void> updateAdvertisement(AdvertisementModel ads) async {
    await _service.update(
      path: 'advertisements/${ads.id}',
      data: ads.toFirestore(),
    );
  }

  Future<void> deleteAdvertisement(String adsId) async {
    await _service.delete(path: 'advertisements/$adsId');
  }
}