import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final String? backgroundImage;
  final String? avatarUrl;
  final bool showAvatar;
  final bool enabled;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.backgroundImage,
    this.avatarUrl,
    this.showAvatar = true,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: enabled && onTap != null ? onTap : null,
      child: Container(
        width: 370,
        height: 124,
        decoration: BoxDecoration(
          color: colorScheme.card,
          border: Border.all(color: colorScheme.border, width: 1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: theme.shadows.sm,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              if (backgroundImage != null) _buildBackgroundImage(),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        colorScheme.card,
                        colorScheme.card.withOpacity(0.5),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 28,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              course.name,
                              style: textTheme.h4.copyWith(
                                color: colorScheme.foreground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.description ?? '',
                                  style: textTheme.muted.copyWith(
                                    color: colorScheme.mutedForeground,
                                  ),
                                ),
                                Text(
                                  course.teacherName ?? '',
                                  style: textTheme.muted.copyWith(
                                    color: colorScheme.foreground,
                                  ),

                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          if (showAvatar && avatarUrl != null) ...[
                            const SizedBox(width: 12),
                            _buildAvatar(colorScheme, theme),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    if (backgroundImage == null) return const SizedBox.shrink();

    final isNetwork =
        backgroundImage!.startsWith('http://') ||
        backgroundImage!.startsWith('https://');

    return Positioned.fill(
      child: isNetwork
          ? Image.network(
              backgroundImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            )
          : Image.asset(
              backgroundImage!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
    );
  }

  Widget _buildAvatar(ShadColorScheme colorScheme, ShadThemeData theme) {
    if (avatarUrl == null) return const SizedBox.shrink();

    final isNetwork =
        avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://');

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: theme.shadows.sm,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: isNetwork
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.muted,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.mutedForeground,
                    size: 20,
                  ),
                ),
              )
            : Image.asset(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.muted,
                  child: Icon(
                    Icons.person,
                    color: colorScheme.mutedForeground,
                    size: 20,
                  ),
                ),
              ),
      ),
    );
  }
}
