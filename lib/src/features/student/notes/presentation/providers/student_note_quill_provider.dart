import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../courses/data/models/course_model.dart';
import '../../../courses/data/repositories/course_firestore_repository.dart';

final ownedCoursesProvider = FutureProvider.autoDispose.family<List<CourseModel>, String>((ref, userId) {
  return ref.watch(courseFirestoreRepositoryProvider).getCoursesByUserId(userId);
});