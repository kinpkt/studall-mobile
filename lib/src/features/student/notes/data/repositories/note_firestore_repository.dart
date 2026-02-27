import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firestore_service.dart';
import '../models/note_model.dart';

final noteFirestoreRepositoryProvider = Provider<NoteFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return NoteFirestoreRepository(firestoreService);
});

class NoteFirestoreRepository {
  final FirestoreService _service;

  NoteFirestoreRepository(this._service);

  Future<void> addNote(NoteModel note) async {
    await _service.add(
      collectionPath: 'notes',
      data: note.toFirestore()
    );
  }

  Future<List<NoteModel>> getNotesByUserId(String userId) async {
    final data = await _service.getCollection(
      path: 'notes/',
      queryBuilder: (query) => query.where('userId', isEqualTo: userId),
      builder: (data, docId) => NoteModel.fromFirestore(data, docId),
    );

    return data ?? [];
  }

  Future<void> updateNote(NoteModel note) async {
    await _service.update(
      path: 'notes/${note.id}',
      data: note.toFirestore(),
    );
  }
}