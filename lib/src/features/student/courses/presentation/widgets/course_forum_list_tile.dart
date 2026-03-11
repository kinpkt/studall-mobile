import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/utils/datetime_to_thai_string.dart';
import 'package:studall/src/features/student/common_widgets/confirm_delete_dialog.dart';
import 'package:studall/src/features/student/common_widgets/resource_icon.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/data/repositories/utility_firestore_repository.dart';
import 'package:studall/src/features/student/courses/presentation/providers/course_forums_provider.dart';

class CourseForumListTile extends ConsumerWidget {
  final UtilityModel item;

  const CourseForumListTile({super.key, required this.item});

  String _formatDate(DateTime date) {
    return dateTimeToThaiString(date, acronymMonth: true, withYear: false);
  }

  String? _formatDeadline(UtilityModel item) {
    if (item.type != UtilityType.toDo || item.endDateTime == null) return null;
    return 'ครบกำหนด ${dateTimeToThaiString(item.endDateTime!, acronymMonth: true, withYear: false, withTime: true)}';
  }

  void _showDetailDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadDialog(
            title: Text(item.title ?? 'ไม่มีชื่อ'),
            description: Text(
              '${item.description != null ? '${item.description}\n' : ''}'
              'สร้างเมื่อ ${_formatDate(item.createdAt)}'
              '${item.endDateTime != null ? '\n${_formatDeadline(item) ?? ''}' : ''}',
            ),
            actions: [
              ShadButton.secondary(
                child: const Text('ปิด'),
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
              ShadButton.destructive(
                child: const Text('ลบ'),
                onPressed: () {
                  showConfirmDeleteDialog(
                    dialogContext,
                    onConfirm: () async {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser == null) {
                        throw Exception('ผู้ใช้ยังไม่ได้เข้าสู่ระบบ');
                      }
                      await ref
                          .read(utilityFirestoreRepositoryProvider)
                          .deleteUtility(currentUser.uid, item.id);
                    },
                    onSuccess: () {
                      if (!dialogContext.mounted) return;
                      Navigator.of(dialogContext).pop();

                      if (item.courseId != null) {
                        ref.invalidate(forumListProvider(item.courseId!));
                      }

                      if (!context.mounted) return;
                      ShadToaster.of(context).show(
                        const ShadToast(
                          title: Text('สำเร็จ'),
                          description: Text('ลบรายการเรียบร้อยแล้ว'),
                        ),
                      );
                    },
                    onError: () {
                      if (!context.mounted) return;
                      ShadToaster.of(context).show(
                        ShadToast.destructive(
                          title: const Text('เกิดข้อผิดพลาด'),
                          description: const Text('ไม่สามารถลบข้อมูลได้'),
                        ),
                      );
                    },
                  );
                },
              ),
              if (item.type == UtilityType.note)
                ShadButton(
                  child: const Text('เปิดบันทึก'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.push('/student/notes/editor', extra: item);
                  },
                ),
              if (item.type == UtilityType.toDo ||
                  item.type == UtilityType.appointment)
                ShadButton(
                  child: const Text('แก้ไขงาน'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.push('/student/tasks/add-edit', extra: item);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final deadline = _formatDeadline(item);

    return GestureDetector(
      onTap: () => _showDetailDialog(context, ref),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.muted,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            ResourceIcon(type: item.type),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title ?? 'ไม่มีชื่อ',
                    style: textTheme.custom['medium']?.copyWith(
                      color: colorScheme.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        _formatDate(item.createdAt),
                        style: textTheme.muted.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                      if (deadline != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: colorScheme.mutedForeground,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            deadline,
                            style: textTheme.muted.copyWith(
                              color: colorScheme.mutedForeground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
