import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/core/theme/theme_extension.dart';

class StoreListTile extends StatelessWidget {
  final String topic;
  final String description;
  final double? distanceInMeters;
  final VoidCallback? onTap;

  const StoreListTile({
    super.key,
    required this.topic,
    required this.description,
    this.distanceInMeters,
    this.onTap,
  });

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} เมตร';
    }
    return '${(meters / 1000).toStringAsFixed(1)} กม';
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: colorScheme.background),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.custom['orange'],
                borderRadius: BorderRadius.circular(12),
                boxShadow: theme.shadows.sm,
              ),
              child: Center(
                child: Icon(
                  PhosphorIconsRegular.storefront,
                  color: colorScheme.custom['orangeForeground'],
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    topic,
                    style: textTheme.custom['medium']?.copyWith(
                      color: colorScheme.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: textTheme.muted.copyWith(
                      color: colorScheme.mutedForeground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (distanceInMeters != null) ...[
              Text(
                _formatDistance(distanceInMeters!),
                style: textTheme.muted.copyWith(
                  color: colorScheme.mutedForeground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
