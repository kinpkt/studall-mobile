import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';

class CourseCard extends StatelessWidget {
  /// The course code/name displayed at the top.
  final String courseName;

  /// The section information (e.g., "หมู่ 1, 200").
  final String section;

  /// The teacher's name displayed at the bottom.
  final String teacherName;

  /// Optional background image path (asset or network).
  final String? backgroundImage;

  /// Optional avatar URL or asset path.
  final String? avatarUrl;

  /// Whether to show the avatar. Defaults to true.
  final bool showAvatar;

  /// Whether the course card is enabled. Defaults to true.
  final bool enabled;

  /// Called when the user taps the card.
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.section,
    required this.teacherName,
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
              // Background Image
              if (backgroundImage != null) _buildBackgroundImage(),

              // Gradient Overlays
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
                    // Course Code/Name
                    SizedBox(
                      height: 28,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              courseName,
                              style: TextStyle(
                                fontFamily: 'Google Sans',
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 28 / 20,
                                letterSpacing: -0.5,
                                color: colorScheme.secondaryForeground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Row (Section/Teacher and Avatar)
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
                                // Section
                                Text(
                                  section,
                                  style: TextStyle(
                                    fontFamily: 'Google Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                    color: colorScheme.mutedForeground,
                                  ),
                                ),

                                // Teacher Name
                                Text(
                                  teacherName,
                                  style: TextStyle(
                                    fontFamily: 'Google Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 20 / 14,
                                    color: colorScheme.secondaryForeground,
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
