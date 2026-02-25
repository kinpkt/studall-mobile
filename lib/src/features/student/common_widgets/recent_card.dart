import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/core/utils/datetime_to_thai_string.dart';
import 'package:studall/src/features/student/common_widgets/resource_icon.dart';

import '../data/models/utility_model.dart';

class RecentItemCard extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final shadows = theme.shadows;

    String title = '';
    String label = '';
    String date = '';
    String time = '';

    switch (item) {
      case WorkUtilityModel work:
        // final work = (item as WorkUtilityModel);
        title = work.title ?? 'Untitled Work';
        label = work.courseId;
        date = dateTimeToThaiString(
          work.dueDateTime ?? work.creationTime,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${work.dueDateTime?.hour.toString().padLeft(2, '0')}:${work.dueDateTime?.minute.toString().padLeft(2, '0')}';
        break;
      case MaterialUtilityModel material:
        title = material.title ?? 'Untitled Material';
        label = material.courseId;
        date = dateTimeToThaiString(
          material.creationTime,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${material.creationTime.hour.toString().padLeft(2, '0')}:${material.creationTime.minute.toString().padLeft(2, '0')}';
        break;
      case AnnouncementUtilityModel announcement:
        title = announcement.title ?? 'Untitled Announcement';
        label = announcement.courseId;
        date = dateTimeToThaiString(
          announcement.creationTime,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${announcement.creationTime.hour.toString().padLeft(2, '0')}:${announcement.creationTime.minute.toString().padLeft(2, '0')}';
        break;
      case EventUtilityModel event:
        title = event.title ?? 'Untitled Event';
        label = '';
        date = dateTimeToThaiString(
          event.creationTime,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${event.creationTime.hour.toString().padLeft(2, '0')}:${event.creationTime.minute.toString().padLeft(2, '0')}';
        break;
      case NoteUtilityModel note:
        title = note.title ?? 'Untitled Note';
        label = '';
        date = dateTimeToThaiString(
          note.creationTime,
          withYear: false,
          acronymMonth: true,
          withTime: false,
        );
        time =
            '${note.creationTime.hour.toString().padLeft(2, '0')}:${note.creationTime.minute.toString().padLeft(2, '0')}';
        break;
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
            style: textTheme.custom['medium']?.copyWith(
              color: colorScheme.foreground,
            ),
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
                      Text(
                        label,
                        style: textTheme.muted.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            date,
                            style: textTheme.small.copyWith(
                              color: colorScheme.foreground,
                            ),
                          ),
                          if (showTime && item is WorkUtilityModel) ...[
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
                if (item is AnnouncementUtilityModel)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: shadows.sm,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: avatarUrl!.isNotEmpty
                        ? Image.network(
                            avatarUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: colorScheme.muted,
                                child: Icon(
                                  PhosphorIconsRegular.user,
                                  color: colorScheme.mutedForeground,
                                  size: 20,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: colorScheme.muted,
                            child: Icon(
                              PhosphorIconsRegular.user,
                              color: colorScheme.mutedForeground,
                              size: 20,
                            ),
                          ),
                  )
                else
                  ResourceIcon(type: item.type),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
