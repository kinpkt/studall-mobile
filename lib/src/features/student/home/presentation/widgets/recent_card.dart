import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/core/utils/datetime_to_thai_string.dart';
import 'package:studall/src/features/student/common_widgets/resource_icon.dart';

import '../../../data/models/utility_model.dart';
import '../providers/home_controller.dart';

class RecentItemCard extends ConsumerWidget {
  final UtilityModel item;
  final bool showTime;
  final String? avatarUrl;

  const RecentItemCard({
    super.key,
    required this.item,
    this.showTime = true,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final shadows = theme.shadows;

    String title = '';
    String label = '';
    String date = '';
    String time = '';

    switch (item.type) {
      case UtilityType.toDo:
        title = item.title ?? 'ภาระงานที่ไม่ได้ถูกตั้งชื่อ';
        label = item.courseId ?? '';
        date = dateTimeToThaiString(
          item.endDateTime ?? item.createdAt,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${item.endDateTime?.hour.toString().padLeft(2, '0')}:${item.endDateTime?.minute.toString().padLeft(2, '0')}';
        break;
      // case UtilityType.shortAnswerQuestion:
      //   title = item.title ?? 'Untitled Short Answer Question';
      //   label = item.courseId ?? '';
      // case UtilityType.multipleChoiceQuestion:
      //   title = item.title ?? 'Untitled Multiple Choice Question';
      //   label = item.courseId ?? '';
      // case UtilityType.material:
      //   title = item.title ?? 'Untitled Material';
      //   label = item.courseId ?? '';
      //   date = dateTimeToThaiString(
      //     item.createdAt,
      //     withYear: false,
      //     acronymMonth: true,
      //     withTime: false,
      //   );
      //   time =
      //       '${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}';
      //   break;
      case UtilityType.note:
        title = item.title ?? 'Untitled Note';
        date = dateTimeToThaiString(
          item.createdAt,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${item.createdAt.hour.toString().padLeft(2, '0')}:${item.createdAt.minute.toString().padLeft(2, '0')}';
        break;
      case UtilityType.appointment:
        title = item.title ?? 'การนัดหมายที่ไม่ได้ตั้งชื่อ';
        date = dateTimeToThaiString(
          item.endDateTime ?? item.createdAt,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${item.endDateTime?.hour.toString().padLeft(2, '0')}:${item.endDateTime?.minute.toString().padLeft(2, '0')}';
        break;
    }

    Widget buildCourseLabel() {
      final textStyle = textTheme.muted.copyWith(
        color: colorScheme.mutedForeground,
      );

      if (item.courseId == null || item.courseId!.isEmpty) {
        return Text(
          'ไม่มีรายวิชา',
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }

      final courseAsync = ref.watch(courseNameProvider(item.courseId!));

      return courseAsync.when(
        data: (name) => Text(
          name ?? '',
          style: textStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        loading: () => const SizedBox(
          height: 12,
          width: 12,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        error: (_, __) => Text(
          'โหลดข้อมูลล้มเหลว',
          style: textStyle.copyWith(color: colorScheme.destructive),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Container(
      width: 186,
      height: 104,
      decoration: BoxDecoration(
        color: colorScheme.card,
        border: Border.all(color: colorScheme.border, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: shadows.sm,
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.list.copyWith(color: colorScheme.foreground),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildCourseLabel(),
                      Row(
                        children: [
                          Text(
                            date,
                            style: textTheme.small.copyWith(
                              color: colorScheme.foreground,
                            ),
                          ),
                          if (showTime && item.type == UtilityType.toDo) ...[
                            const SizedBox(width: 2),
                            Text(
                              time,
                              style: textTheme.small.copyWith(
                                color: colorScheme.foreground,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ResourceIcon(type: item.type),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
