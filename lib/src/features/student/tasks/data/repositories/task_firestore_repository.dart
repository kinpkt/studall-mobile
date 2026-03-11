import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firestore_service.dart';
import '../../../data/models/utility_model.dart';
import '../../../home/data/models/schedule_model.dart';
import '../models/task_model.dart';

final taskFirestoreRepositoryProvider = Provider<TaskFirestoreRepository>((
  ref,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return TaskFirestoreRepository(firestoreService);
});

class TaskFirestoreRepository {
  final FirestoreService _service;

  TaskFirestoreRepository(this._service);

  Future<void> addTask(String userId, TaskModel task) async {
    await _service.set(
      path: 'students/$userId/tasks/${task.id}',
      data: task.toFirestore(),
    );
  }

  Stream<List<TaskModel>> getTasksByUserId(String userId) {
    final data = _service.streamCollection<TaskModel>(
      path: 'students/$userId/tasks',
      builder: (data, docId) => TaskModel.fromFirestore(data, docId),
    );

    return data;
  }

  Future<List<ScheduleModel>> getAllSchedulesFromAllAppointments(
    String userId,
  ) async {
    final tasks = await _service.getCollection<TaskModel>(
      path: 'students/$userId/tasks',
      builder: (data, docId) => TaskModel.fromFirestore(data, docId),
    );

    return (tasks)
        .where(
          (task) =>
              task.type == 'appointment' && task.isShownInSchedule == true,
        )
        .map((task) => ScheduleModel.fromAppointment(task))
        .toList();
  }

  Future<void> updateTask(String userId, TaskModel task) async {
    await _service.update(
      path: 'students/$userId/tasks/${task.id}',
      data: task.toFirestore(),
    );
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _service.delete(path: 'students/$userId/tasks/$taskId');
  }

  Future<void> deleteTasksByCourseId(String userId, String courseId) async {
    final tasks = await _service.getCollection<TaskModel>(
      path: 'students/$userId/tasks',
      builder: (data, docId) => TaskModel.fromFirestore(data, docId),
      queryBuilder: (query) => query.where('courseId', isEqualTo: courseId),
    );
    for (final task in tasks) {
      await _service.delete(path: 'students/$userId/tasks/${task.id}');
    }
  }
}
