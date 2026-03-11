import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/data/repositories/utility_firestore_repository.dart';

final forumListProvider = FutureProvider.autoDispose.family<List<UtilityModel>, String>((ref, courseId) {
  final currentUser = FirebaseAuth.instance.currentUser;

  final repository = ref.read(utilityFirestoreRepositoryProvider);
  return repository.getUtilitiesByUserIdAndCourseId(currentUser!.uid, courseId);
});