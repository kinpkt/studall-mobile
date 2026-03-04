import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    required this.title,
    this.titleStyle,
    this.description,
    this.descriptionStyle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onDoubleTap,
  });

  final EdgeInsetsGeometry? padding;
  final String title;
  final TextStyle? titleStyle;
  final String? description;
  final TextStyle? descriptionStyle;
  final Widget? leading;
  final List<Widget>? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 16)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        titleStyle ??
                        textTheme.p.copyWith(color: colorScheme.foreground),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null)
                    Text(
                      description!,
                      style:
                          descriptionStyle ??
                          textTheme.muted.copyWith(
                            color: colorScheme.mutedForeground,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (trailing != null && trailing!.isNotEmpty) ...[
              const SizedBox(width: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: trailing!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
