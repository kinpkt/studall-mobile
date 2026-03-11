import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/app_list_tile.dart';
import 'package:studall/src/core/utils/datetime_to_thai_string.dart';
import 'package:studall/src/features/student/common_widgets/confirm_delete_dialog.dart';
import 'package:studall/src/features/student/common_widgets/resource_icon.dart';
import 'package:studall/src/features/student/data/repositories/utility_firestore_repository.dart';
import 'package:studall/src/features/student/tasks/data/repositories/task_firestore_repository.dart';

import '../../../home/presentation/providers/home_controller.dart';
import '../../data/models/task_model.dart';

class TaskTile extends ConsumerWidget {
  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final dueDateColor = colorScheme.custom['success'] ?? Colors.green;
    final dateStyle = textTheme.muted.copyWith(color: dueDateColor);

    String descriptionText = 'อื่น ๆ';

    if (task.courseId != null && task.courseId!.isNotEmpty) {
      final courseAsync = ref.watch(courseNameProvider(task.courseId!));

      descriptionText = courseAsync.when(
        data: (name) => name != null ? 'วิชา: $name' : 'อื่น ๆ',
        loading: () => 'กำลังโหลด...',
        error: (_, _) => 'โหลดข้อมูลล้มเหลว',
      );
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (mainDialogContext) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShadDialog(
                title: Text(task.title),
                description: Text(
                  '$descriptionText'
                  '${task.description != null ? '\nรายละเอียด: ${task.description}' : ''}'
                  '\n${task.type == TaskType.toDo ? 'กำหนดส่ง: ${dateTimeToThaiString(task.endDateTime, withTime: true, withDayOfWeek: true)}' : 'ระยะเวลา: ${dateTimeToThaiString(task.startDateTime!, withTime: true, withDayOfWeek: true)} - ${dateTimeToThaiString(task.endDateTime, withTime: true, withDayOfWeek: true)}'}',
                ),
                actions: [
                  ShadButton.secondary(
                    child: const Text('ปิด'),
                    onPressed: () => context.pop(),
                  ),
                  ShadButton.destructive(
                    child: const Text('ลบ'),
                    onPressed: () {
                      showConfirmDeleteDialog(
                        mainDialogContext,
                        description:
                            'คุณแน่ใจหรือไม่ว่าต้องการลบงานนี้? การกระทำนี้ไม่สามารถย้อนกลับได้',
                        onConfirm: () async {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser == null) {
                            throw Exception('ผู้ใช้ยังไม่ได้เข้าสู่ระบบ');
                          }
                          await ref
                              .read(taskFirestoreRepositoryProvider)
                              .deleteTask(currentUser.uid, task.id);
                          await ref
                              .read(utilityFirestoreRepositoryProvider)
                              .deleteUtility(currentUser.uid, task.id);
                        },
                        onSuccess: () {
                          if (!mainDialogContext.mounted) return;
                          Navigator.of(mainDialogContext).pop();

                          if (!context.mounted) return;
                          ShadToaster.of(context).show(
                            const ShadToast(
                              title: Text('สำเร็จ'),
                              description: Text('ลบงานเรียบร้อยแล้ว'),
                            ),
                          );
                          context.pop();
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
                  if (!task.isDone)
                    ShadButton(
                      child: const Text('เสร็จสิ้น'),
                      onPressed: () {
                        final updatedTask = task.copyWith(isDone: true);
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) return;

                        ref
                            .read(taskFirestoreRepositoryProvider)
                            .updateTask(currentUser.uid, updatedTask);

                        context.pop();

                        ShadToaster.of(context).show(
                          const ShadToast(
                            title: Text('สำเร็จ'),
                            description: Text(
                              'ปรับสถานะให้งานเสร็จสิ้นเรียบร้อยแล้ว',
                            ),
                          ),
                        );
                      },
                    ),
                  if (task.isDone)
                    ShadButton(
                      child: const Text('ปรับให้งานยังไม่เสร็จ'),
                      onPressed: () {
                        final updatedTask = task.copyWith(isDone: false);
                        final currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser == null) return;

                        ref
                            .read(taskFirestoreRepositoryProvider)
                            .updateTask(currentUser.uid, updatedTask);

                        Navigator.of(context).pop();

                        ShadToaster.of(context).show(
                          const ShadToast(
                            title: Text('สำเร็จ'),
                            description: Text(
                              'ปรับสถานะให้งานไม่เสร็จเรียบร้อยแล้ว',
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
      child: AppListTile(
        leading: task.isDone
            ? Opacity(opacity: 0.15, child: ResourceIcon(type: task.type))
            : ResourceIcon(type: task.type),
        title: task.title,
        titleStyle: textTheme.list.copyWith(color: colorScheme.foreground),
        description: descriptionText,
        descriptionStyle: textTheme.muted.copyWith(
          color: colorScheme.mutedForeground,
        ),
        trailing: [
          if (task.isDone)
            Text(
              'เสร็จสิ้น',
              style: textTheme.muted.copyWith(
                color: colorScheme.mutedForeground,
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_formatDueDate(task.endDateTime), style: dateStyle),
                Text(
                  '${task.endDateTime.hour.toString().padLeft(2, '0')}:${task.endDateTime.minute.toString().padLeft(2, '0')}',
                  style: dateStyle,
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final thisWeek = today.add(const Duration(days: 7));
    final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);

    if (taskDate == today) {
      return 'วันนี้';
    } else if (taskDate == tomorrow) {
      return 'พรุ่งนี้';
    } else if (taskDate.isAfter(today) && taskDate.isBefore(thisWeek)) {
      final dayNames = ['จ.', 'อ.', 'พ.', 'พฤ.', 'ศ.', 'ส.', 'อา.'];
      final dayName = dayNames[dueDate.weekday - 1];
      return 'วัน $dayName';
    } else {
      return dateTimeToThaiString(
        dueDate,
        withDayOfWeek: false,
        acronymMonth: true,
        withYear: false,
      );
    }
  }
}
