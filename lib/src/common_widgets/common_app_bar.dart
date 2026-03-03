import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final List<Widget>? leading;
  final String? title;
  final String? subtitle;

  const CommonAppbar({
    super.key,
    this.actions,
    this.leading,
    this.title,
    this.subtitle,
  });

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (leading != null) ...leading! else const SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (title != null)
                        Text(
                          title!,
                          style: theme.textTheme.h4.copyWith(
                            color: colorScheme.foreground,
                          ),
                        )
                      else
                        const SizedBox(),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      if (actions != null) ...actions! else const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),

            if (subtitle != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    subtitle!,
                    style: theme.textTheme.p.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
