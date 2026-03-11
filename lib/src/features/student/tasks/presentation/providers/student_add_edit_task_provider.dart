import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';

import '../../../data/repositories/utility_firestore_repository.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_firestore_repository.dart';

final studentAddEditTaskProvider = AsyncNotifierProvider<StudentAddEditTaskController, void>(() {
  return StudentAddEditTaskController();
});

final taskTypeProvider = NotifierProvider<TaskTypeController, TaskType>(() {
  return TaskTypeController();
});

class StudentAddEditTaskController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> submitTask(TaskModel task, bool isNewTask) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null)
      throw Exception('User not authenticated');

    state = const AsyncValue.loading();

    try {
      final taskRepository = ref.read(taskFirestoreRepositoryProvider);
      final utilityRepository = ref.read(utilityFirestoreRepositoryProvider);

      final newUtility = UtilityModel.fromTaskModel(task);

      await (isNewTask ? taskRepository.addTask(currentUser.uid, task) : taskRepository.updateTask(currentUser.uid, task));
      await (isNewTask ? utilityRepository.addUtility(currentUser.uid, newUtility) : utilityRepository.updateUtility(currentUser.uid, newUtility));

      state = const AsyncValue.data(null);
    }
    catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }
}

class TaskTypeController extends Notifier<TaskType> {
  @override
  TaskType build() {
    return TaskType.toDo;
  }

  void setTaskType(TaskType newType) {
    state = newType;
  }
}