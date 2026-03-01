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

class StudentCoursesScreen extends ConsumerWidget {
  const StudentCoursesScreen({super.key});

  void _showAddCourseModal(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) {
        return AddEditCourseModal();
      },
    );
  }

  Widget _inlineIconButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = ShadTheme.of(context);
    return ShadIconButton.ghost(
      onPressed: onPressed,
      icon: Icon(icon),
      height: 24,
      foregroundColor: theme.colorScheme.mutedForeground,
      iconSize: 20,
      padding: EdgeInsets.symmetric(horizontal: 8),
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

    final ownedCourses = ref
        .watch(courseFirestoreRepositoryProvider)
        .getCoursesByUserId(currentUser.uid);

    return Container(
      color: theme.colorScheme.background,
      padding: const EdgeInsets.all(16),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'วิชา',
                    style: textTheme.custom['medium']?.copyWith(
                      color: colorScheme.foreground,
                    ),
                  ),
                ],
              ),
              _inlineIconButton(
                context: context,
                icon: PhosphorIconsBold.plus,
                onPressed: () => _showAddCourseModal(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<CourseModel>>(
              future: ownedCourses,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final courses = snapshot.data ?? [];

                if (courses.isEmpty) {
                  return Center(
                    child: Text('ยังไม่มีวิชา', style: theme.textTheme.p),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
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
