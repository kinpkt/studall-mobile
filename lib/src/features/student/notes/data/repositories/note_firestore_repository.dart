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

  Future<void> addNote(String userId, NoteModel note) async {
    await _service.set(
      path: 'students/$userId/notes/${note.id}',
      data: note.toFirestore()
    );
  }

  Stream<List<NoteModel>> getNotesByUserId(String userId) {
    final data = _service.streamCollection<NoteModel>(
      path: 'students/$userId/notes/',
      builder: (data, docId) => NoteModel.fromFirestore(data, docId),
    );

    return data;
  }

  Future<void> updateNote(String userId, NoteModel note) async {
    await _service.update(
      path: 'students/$userId/notes/${note.id}',
      data: note.toFirestore(),
    );
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await _service.delete(
      path: 'students/$userId/notes/$noteId',
    );
  }
}