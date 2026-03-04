import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';

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
  final UtilityType type;

  const ResourceIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    ResourceIconStyle getStyleForType(UtilityType type) {
      switch (type) {
        case UtilityType.assignment:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['blue'] ?? Colors.blue,
            iconColor: colorScheme.custom['blueForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.fileText,
          );
        case UtilityType.shortAnswerQuestion:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['orange'] ?? Colors.orange,
            iconColor: colorScheme.custom['orangeForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.sealQuestion,
          );
        case UtilityType.multipleChoiceQuestion:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['orange'] ?? Colors.orange,
            iconColor: colorScheme.custom['orangeForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.sealQuestion,
          );
        case UtilityType.material:
          return ResourceIconStyle(
            backgroundColor: colorScheme.custom['gray'] ?? Colors.grey,
            iconColor: colorScheme.custom['grayForeground'] ?? Colors.white,
            iconData: PhosphorIconsRegular.fileText,
          );
        case UtilityType.event:
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
