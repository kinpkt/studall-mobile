import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/interfaces/resource_type.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';

import '../tasks/data/models/task_model.dart';

class ResourceIconStyle {
  final Color backgroundColor;
  final Color iconColor;
  final IconData iconData;

  const ResourceIconStyle({
    required this.backgroundColor,
    required this.iconColor,
    required this.iconData,
  });
}

class ResourceIcon extends StatelessWidget {
  final ResourceType type;

  const ResourceIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    ResourceIconStyle getStyleForType(ResourceType type) {
      switch (type) {
        case TaskType.toDo:
        case UtilityType.toDo:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['blue'] ?? Colors.blue,
            iconColor: colorScheme.custom['blueForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.fileText,
          );
        // case UtilityType.shortAnswerQuestion:
        //   return ResourceIconStyle(
        //     backgroundColor: colorScheme.custom['orange'] ?? Colors.orange,
        //     iconColor: colorScheme.custom['orangeForeground'] ?? Colors.white,
        //     iconData: PhosphorIconsRegular.sealQuestion,
        //   );
        // case UtilityType.multipleChoiceQuestion:
        //   return ResourceIconStyle(
        //     backgroundColor: colorScheme.custom['orange'] ?? Colors.orange,
        //     iconColor: colorScheme.custom['orangeForeground'] ?? Colors.white,
        //     iconData: PhosphorIconsRegular.sealQuestion,
        //   );
        case UtilityType.note:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['gray'] ?? Colors.grey,
            iconColor: colorScheme.custom['grayForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.fileText,
          );
        case TaskType.appointment:
        case UtilityType.appointment:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['purple'] ?? Colors.purple,
            iconColor: colorScheme.custom['purpleForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.calendarCheck,
          );
        default:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['gray'] ?? Colors.grey,
            iconColor: colorScheme.custom['grayForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.fileText,
          );
      }
    }

    final style = getStyleForType(type);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(style.iconData, color: style.iconColor, size: 24),
    );
  }
}
