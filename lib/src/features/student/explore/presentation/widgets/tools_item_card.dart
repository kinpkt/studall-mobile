import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ToolsItemCard extends StatelessWidget {
  final String name;
  final String path;
  const ToolsItemCard({super.key, required this.name, required this.path});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadButton(
      width: 240,
      height: 50,
      child: Text(name, style: theme.textTheme.h4,),
      onPressed: () {
        context.push(path);
      },
    );
  }
}
