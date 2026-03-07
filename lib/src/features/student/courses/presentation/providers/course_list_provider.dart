import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/course_model.dart';
import '../../data/repositories/course_firestore_repository.dart';

final userCoursesProvider = FutureProvider.autoDispose<List<CourseModel>>((ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    return [];
  }

  final repository = ref.read(courseFirestoreRepositoryProvider);
  return repository.getCoursesByUserId(currentUser.uid);
});
