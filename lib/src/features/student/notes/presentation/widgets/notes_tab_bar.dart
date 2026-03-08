import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NotesTabBar extends StatelessWidget {
  const NotesTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child: ShadInput(
        placeholder: Text('ค้นหาบันทึก'),
        leading: Padding(
          padding: EdgeInsets.all(4.0),
          child: Icon(
            PhosphorIconsRegular.magnifyingGlass,
            color: colorScheme.foreground,
          ),
        ),
      ),
    );
  }
}
