import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/services/firestore_service.dart';
import '../../../data/models/utility_model.dart';
import '../../../home/data/models/schedule_model.dart';
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

  Future<List<ScheduleModel>> getTodaySchedulesFromAllAppointments(String userId) async {
    final tasks = await _service.getCollection<TaskModel>(
      path: 'students/$userId/tasks',
      builder: (data, docId) => TaskModel.fromFirestore(data, docId),
    );

    final now = DateTime.now();

    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    return tasks
        .where((task) {
      if (task.type != TaskType.appointment ||
          task.isShownInSchedule != true ||
          task.startDateTime == null) {
        return false;
      }

      return task.startDateTime!.compareTo(endOfToday) <= 0 &&
              task.endDateTime.compareTo(startOfToday) >= 0;
        })
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
    await _service.delete(
      path: 'students/$userId/tasks/$taskId',
    );
  }
}