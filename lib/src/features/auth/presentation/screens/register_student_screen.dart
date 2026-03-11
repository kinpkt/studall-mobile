import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/data/models/role.dart';
import 'package:studall/src/features/auth/presentation/controllers/auth_state_provider.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/course_card.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/add_edit_course_modal.dart';
import 'package:studall/src/features/auth/data/repositories/user_firestore_repository.dart';

class RegisterStudentScreen extends ConsumerStatefulWidget {
  const RegisterStudentScreen({super.key});

  @override
  ConsumerState<RegisterStudentScreen> createState() =>
      _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends ConsumerState<RegisterStudentScreen> {
  late List<CourseModel> courses = [];

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Text(
                      'เพิ่มวิชาเรียนเริ่มต้น',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.h3.copyWith(
                        color: colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'เพิ่มวิชาเรียนเริ่มต้นที่คุณกำลังเรียนในเทอมนี้',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.muted.copyWith(
                        color: colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          () => _showAddCourseModal(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: (courses.isEmpty)
                          ? Column(
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
                                  onPressed: () => _showAddCourseModal(context),
                                  child: Text(
                                    'สร้างวิชาเรียนใหม่ที่นี่',
                                    style: theme.textTheme.p.copyWith(
                                      color: colorScheme.custom['info']!,
                                      fontWeight: FontWeight.w500,
                                      // decoration: TextDecoration.underline,
                                      decorationColor:
                                          colorScheme.custom['info']!,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SingleChildScrollView(
                              child: Column(
                                spacing: 16,
                                children: [
                                  ...courses.asMap().entries.map(
                                    (entry) => CourseCard(
                                      course: entry.value,
                                      onTap: () => _showEditCourseModal(
                                        context,
                                        entry.key,
                                        entry.value,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (courses.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 32.0, 16.0, 0),
                        child: ShadButton(
                          enabled: courses.isNotEmpty,
                          onPressed: () => _handleSaveCourses(context),
                          size: ShadButtonSize.lg,
                          width: double.infinity,
                          child: const Text('บันทึกวิชาเรียน'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCourseModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddEditCourseModal(
        onSave: (course) => setState(() => courses.add(course)),
      ),
    );
  }

  void _showEditCourseModal(
    BuildContext context,
    int index,
    CourseModel course,
  ) {
    showDialog(
      context: context,
      builder: (_) => AddEditCourseModal(
        course: course,
        onSave: (updated) => setState(() => courses[index] = updated),
      ),
    );
  }

  Future<void> _handleSaveCourses(BuildContext context) async {
    final authState = ref.read(authStateProvider);
    final userId = authState.value?.uid;
    if (userId == null) return;

    final repoCourses = ref.read(courseFirestoreRepositoryProvider);
    await Future.wait(
      courses.map((course) => repoCourses.addCourse(userId, course)),
    );
    final repoUsers = ref.read(userFirestoreRepositoryProvider);
    await repoUsers.addUserRole(userId, Role.student);
    await repoUsers.updateUserLastActiveRole(userId, Role.student);

    if (context.mounted) context.go('/student/home');
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

  CommonAppbar _buildAppBar(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return CommonAppbar(
      leading: [
        ShadIconButton.ghost(
          decoration: ShadDecoration(shape: BoxShape.circle),
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ],
      actions: [
        ShadButton.ghost(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          decoration: ShadDecoration(shape: BoxShape.circle),
          child: Row(
            spacing: 8,
            children: [
              Text(
                'ข้ามไปก่อน',
                style: theme.textTheme.p.copyWith(
                  color: colorScheme.foreground,
                ),
              ),
              Icon(
                PhosphorIconsRegular.caretDoubleRight,
                color: colorScheme.foreground,
              ),
            ],
          ),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
