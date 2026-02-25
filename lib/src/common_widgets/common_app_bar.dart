import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final List<Widget>? leading;

  const CommonAppbar({super.key, this.actions, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(92);

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...leading!,
            const Spacer(),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
