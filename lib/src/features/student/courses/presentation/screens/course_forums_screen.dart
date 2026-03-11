import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/presentation/providers/course_forums_provider.dart';

class CourseForumsScreen extends ConsumerWidget {
  final String courseId;

  const CourseForumsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumsAsync = ref.watch(forumListProvider(courseId));

    return forumsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('เกิดข้อผิดพลาด: $error'),
      ),
      data: (forums) {
        if (forums.isEmpty) {
          return const Center(
            child: Text('ไม่มีฟอรั่มในรายวิชานี้'),
          );
        }

        return ListView.builder(
          itemCount: forums.length,
          itemBuilder: (context, index) {
            final forum = forums[index];
            return ListTile(
              title: Text(forum.title ?? 'เนื้อหาที่ไม่ระบุชื่อ'),
              subtitle: Text('ID: ${forum.id}'),
            );
          },
        );
      },
    );
  }
}
