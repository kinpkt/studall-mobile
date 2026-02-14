import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/utils/datetime_to_thai_string.dart';

class ToolsItemCard extends StatelessWidget {
  final String name;
  final String path;
  const ToolsItemCard({super.key, required this.name, required this.path});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // TO-DO: add routing to the designated tool route

    return ShadButton(
      width: 240,
      height: 50,
      child: Text(name, style: theme.textTheme.h4,),
    );
  }
}
