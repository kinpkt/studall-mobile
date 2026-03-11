import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studall/src/core/theme/theme_extension.dart';

import 'package:shadcn_ui/shadcn_ui.dart';

class ToolsItemCard extends StatelessWidget {
  final String name;
  final String path;
  const ToolsItemCard({super.key, required this.name, required this.path});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final shadows = theme.shadows;

    return GestureDetector(
      onTap: () {
        context.push(path);
      },
      child: Container(
        width: 186,
        height: 104,
        decoration: BoxDecoration(
          color: colorScheme.card,
          border: Border.all(color: colorScheme.border, width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: shadows.sm,
        ),
        alignment: Alignment.center,
        child: Text(name, style: textTheme.h4),
      ),
    );
    // return ShadButton(
    //   width: 240,
    //   height: 50,
    //   child: Text(name, style: theme.textTheme.h4,),
    //   onPressed: () {
    //     context.push(path);
    //   },
    // );
  }
}
