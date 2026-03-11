import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/course_model.dart';
import '../../data/repositories/course_firestore_repository.dart';

final userCoursesProvider = StreamProvider.autoDispose<List<CourseModel>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  final repository = ref.read(courseFirestoreRepositoryProvider);
  return repository.getCoursesByUserId(currentUser!.uid);
});

final courseByIdProvider = FutureProvider.autoDispose.family<CourseModel?, String>((ref, courseId) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return null;
  }

  final repository = ref.read(courseFirestoreRepositoryProvider);
  return repository.getCourseById(currentUser.uid, courseId);
});
