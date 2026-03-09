import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/add_edit_course_modal.dart';

import '../../../../auth/presentation/screens/log_in_screen.dart';
import '../widgets/course_card.dart';

final userCoursesProvider = FutureProvider.family<List<CourseModel>, String>((
  ref,
  userId,
) {
  final repo = ref.watch(courseFirestoreRepositoryProvider);
  return repo.getCoursesByUserId(userId);
});

class StudentCoursesScreen extends ConsumerWidget {
  const StudentCoursesScreen({super.key});

  void _showAddCourseModal(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    showDialog(
      context: context,
      builder: (_) => AddEditCourseModal(
        onSave: (course) async {
          final repo = ref.read(courseFirestoreRepositoryProvider);
          await repo.addCourse(userId, course);
          ref.invalidate(userCoursesProvider);
        },
      ),
    );
  }

  Widget _iconButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final theme = ShadTheme.of(context);
    return ShadIconButton.ghost(
      onPressed: onPressed,
      icon: Icon(icon),
      height: 24,
      foregroundColor: theme.colorScheme.mutedForeground,
      iconSize: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return LogInScreen();
    }

    final coursesAsync = ref.watch(userCoursesProvider(currentUser.uid));

    return Container(
      color: theme.colorScheme.background,
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'วิชา',
                style: textTheme.custom['medium']?.copyWith(
                  color: colorScheme.foreground,
                ),
              ),
              _iconButton(
                context,
                PhosphorIconsBold.plus,
                () => _showAddCourseModal(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: coursesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('เกิดข้อผิดพลาด: $err')),
              data: (courses) {
                if (courses.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'เริ่มต้นบันทึกรายวิชาของคุณ',
                        style: theme.textTheme.p.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                      ShadButton.ghost(
                        onPressed: () => _showAddCourseModal(context, ref),
                        child: Text(
                          'สร้างวิชาเรียนใหม่ที่นี่',
                          style: theme.textTheme.p.copyWith(
                            color: colorScheme.custom['info']!,
                            fontWeight: FontWeight.w500,
                            decorationColor: colorScheme.custom['info']!,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    children: [
                      ...courses.map((course) => CourseCard(course: course)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
