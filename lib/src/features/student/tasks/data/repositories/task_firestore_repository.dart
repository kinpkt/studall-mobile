import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firestore_service.dart';
import '../../../data/models/utility_model.dart';
import '../models/task_model.dart';

final taskFirestoreRepositoryProvider = Provider<TaskFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return TaskFirestoreRepository(firestoreService);
});

class TaskFirestoreRepository {
  final FirestoreService _service;

  TaskFirestoreRepository(this._service);

  Future<void> addTask(String userId, TaskModel task) async {
    await _service.set(
      path: 'students/$userId/tasks/${task.id}',
      data: task.toFirestore()
    );
  }

  Stream<List<TaskModel>> getTasksByUserId(String userId) {
    final data = _service.streamCollection<TaskModel>(
      path: 'students/$userId/tasks',
      builder: (data, docId) => TaskModel.fromFirestore(data, docId),
    );

    return data;
  }

  Future<void> updateTask(String userId, TaskModel task) async {
    await _service.update(
      path: 'students/$userId/tasks/${task.id}',
      data: task.toFirestore(),
    );
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _service.delete(
      path: 'students/$userId/tasks/$taskId',
    );
  }
}