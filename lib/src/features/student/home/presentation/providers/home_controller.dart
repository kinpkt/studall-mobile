import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/data/repositories/utility_firestore_repository.dart';
import 'package:studall/src/features/student/tasks/data/models/task_model.dart';
import 'package:studall/src/features/student/tasks/data/repositories/task_firestore_repository.dart';

final ownedUtilitiesProvider = FutureProvider<List<UtilityModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser?.uid == null)
    throw Exception('User not authenticated');

  final repository = ref.watch(utilityFirestoreRepositoryProvider);
  return repository.getUtilitiesByUserId(currentUser!.uid);
});

final ownedTasksProvider = FutureProvider<List<TaskModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser?.uid == null)
    throw Exception('User not authenticated');

  final repository = ref.watch(taskFirestoreRepositoryProvider);
  return repository.getTasksByUserId(currentUser!.uid);
});

final courseNameProvider = FutureProvider.family<String?, String>((ref, courseId) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser?.uid == null)
    throw Exception('User not authenticated');

  final repository = ref.watch(courseFirestoreRepositoryProvider);
  final course = await repository.getCourseById(currentUser!.uid, courseId);

  return course?.name;
});