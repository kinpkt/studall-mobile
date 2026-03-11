import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';
import 'package:studall/src/features/student/data/repositories/utility_firestore_repository.dart';
import 'package:studall/src/features/student/notes/data/repositories/note_firestore_repository.dart';
import 'package:studall/src/features/student/tasks/data/repositories/task_firestore_repository.dart';

/// Controller สำหรับจัดการการบันทึกและจัดเก็บวิชาในหน้า Course Settings
final courseSettingControllerProvider =
    AsyncNotifierProvider<CourseSettingController, void>(
      () => CourseSettingController(),
    );

class CourseSettingController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    return;
  }

  /// บันทึกการเปลี่ยนแปลงวิชา
  Future<void> updateCourse(CourseModel course) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      state = AsyncValue.error(Exception('ไม่พบผู้ใช้งาน'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseFirestoreRepositoryProvider);
      await repository.updateCourse(currentUser.uid, course);
    });
  }

  Future<void> archiveCourse(String courseId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      state = AsyncValue.error(Exception('ไม่พบผู้ใช้งาน'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(courseFirestoreRepositoryProvider);
      final course = await repository.getCourseById(currentUser.uid, courseId);
      if (course == null) throw Exception('ไม่พบรายวิชา');

      final archivedCourse = CourseModel(
        id: course.id,
        name: course.name,
        description: course.description,
        teacherName: course.teacherName,
        schedule: course.schedule,
        createdAt: course.createdAt,
        isActive: false,
        inactiveDateTime: DateTime.now(),
      );

      await repository.updateCourse(currentUser.uid, archivedCourse);
    });
  }

  Future<void> deleteCourse(String courseId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      state = AsyncValue.error(Exception('ไม่พบผู้ใช้งาน'), StackTrace.current);
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final courseRepo = ref.read(courseFirestoreRepositoryProvider);
      final noteRepo = ref.read(noteFirestoreRepositoryProvider);
      final taskRepo = ref.read(taskFirestoreRepositoryProvider);
      final utilityRepo = ref.read(utilityFirestoreRepositoryProvider);

      await noteRepo.deleteNotesByCourseId(currentUser.uid, courseId);
      await taskRepo.deleteTasksByCourseId(currentUser.uid, courseId);
      await utilityRepo.deleteUtilitiesByCourseId(currentUser.uid, courseId);
      await courseRepo.deleteCourse(currentUser.uid, courseId);
    });
  }
}
