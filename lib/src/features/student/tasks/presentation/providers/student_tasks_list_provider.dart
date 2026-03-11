import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/tasks/data/models/task_model.dart';
import 'package:studall/src/features/student/tasks/data/repositories/task_firestore_repository.dart';

final studentTasksListProvider = StreamProvider.family<List<TaskModel>, String>((ref, userId) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    throw Exception('User not authenticated');
  }

  final repository = ref.watch(taskFirestoreRepositoryProvider);
  return repository.getTasksByUserId(currentUser.uid);
});