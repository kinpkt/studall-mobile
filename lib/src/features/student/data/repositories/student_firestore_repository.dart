
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/core/services/firestore_service.dart';
import 'package:studall/src/features/student/data/models/student_model.dart';

import '../../courses/data/models/course_schedule_model.dart';
import '../../home/data/models/schedule_model.dart';

final studentFirestoreRepositoryProvider = Provider<StudentFirestoreRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return StudentFirestoreRepository(firestoreService);
});

final studentSettingsProvider = FutureProvider.family<StudentModel?, String>((ref, id) async {
  return ref.read(studentFirestoreRepositoryProvider).getStudentSettings(id);
});

class StudentFirestoreRepository {
  final FirestoreService _service;

  StudentFirestoreRepository(this._service);

  Future<StudentModel?> getStudentSettings(String userId) async {
    final data = await _service.get(
      path: 'students/$userId',
      builder: (data, docId) => StudentModel.fromFirestore(data, docId),
    );

    return data;
  }

  Future<List<ScheduleModel>> getTodaySchedulesInAllCourses(String userId) async {
    final listOfLists = await _service.getCollection<List<ScheduleModel>>(
      path: 'students/$userId/courses',
      builder: (data, docId) {
        final courseTitle = data['name'] as String? ?? 'วิชาที่ไม่ทราบชื่อ';
        final rawSchedules = data['schedule'] as List<dynamic>? ?? [];

        return rawSchedules.map((scheduleData) {
          final courseSchedule = CourseScheduleModel.fromFirestore(scheduleData as Map<String, dynamic>);
          final model = ScheduleModel.fromCourseSchedule(courseSchedule, courseTitle);

          return model;
        }).toList();
      },
    );

    final todayWeekday = DateTime.now().weekday;
    final currentDayOfWeek = DayOfWeek.values[todayWeekday - 1];

    final allSchedules = listOfLists.expand((scheduleList) => scheduleList).toList();

    print('Total schedules before filter: ${allSchedules.length}');
    print('Filtering for: $currentDayOfWeek');

    return allSchedules
        .where((schedule) => schedule.day == currentDayOfWeek)
        .toList();
  }

  Future<void> updateSearchRadius(String id, double radius) async {
    await _service.update(
      path: 'students/$id',
      data: {'radius': radius},
    );
  }
}