import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';

/// A card-style checkbox that can be configured like Flutter's built-in Checkbox.
/// Uses ThemeData TextStyle and ColorScheme from ShadTheme.
///
/// Example:
/// ```dart
/// CheckboxCard(
///   courseCode: '68-2-01418342-MobileApp',
///   section: 'หมู่ 1, 200',
///   teacherName: 'Aurawan IMSOMBUT',
///   value: isSelected,
///   onChanged: (value) => setState(() => isSelected = value ?? false),
///   backgroundImage: 'assets/images/course_bg.png',
///   avatarUrl: 'https://example.com/avatar.jpg',
/// )
/// ```
class CheckboxCard extends StatelessWidget {
  /// The course code/name displayed at the top.
  final String courseCode;

  /// The section information (e.g., "หมู่ 1, 200").
  final String section;

  /// The teacher's name displayed at the bottom.
  final String teacherName;

  /// Whether this checkbox is checked.
  final bool value;

  /// Called when the user toggles the checkbox.
  final ValueChanged<bool?>? onChanged;

  /// Optional background image path (asset or network).
  final String? backgroundImage;

  /// Optional avatar URL or asset path.
  final String? avatarUrl;

  /// Whether to show the avatar. Defaults to true.
  final bool showAvatar;

  /// Whether the checkbox card is enabled. Defaults to true.
  final bool enabled;

  const CheckboxCard({
    super.key,
    required this.courseCode,
    required this.section,
    required this.teacherName,
    required this.value,
    this.onChanged,
    this.backgroundImage,
    this.avatarUrl,
    this.showAvatar = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (value)
          Positioned(
            top: -4,
            left: -4,
            right: -4,
            bottom: -4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.ring, width: 2),
              ),
            ),
          ),
        GestureDetector(
          onTap: enabled && onChanged != null ? () => onChanged!(!value) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(minWidth: 394, minHeight: 124),
            decoration: BoxDecoration(
              color: colorScheme.card,
              border: Border.all(color: colorScheme.border, width: 1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: value ? theme.shadows.md : null,
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
                      color: colorScheme.card.withValues(alpha: .5),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            colorScheme.card,
                            colorScheme.card.withValues(alpha: .5),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 0),
                      opacity: value ? 1.0 : 0.37,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course Code
                          SizedBox(
                            height: 28,
                            child: Text(
                              courseCode,
                              style: theme.textTheme.h4.copyWith(
                                color: colorScheme.secondaryForeground,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Bottom Row (Section/Teacher and Avatar)
                          SizedBox(
                            height: 72,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // Section
                                    Text(
                                      section,
                                      style: theme.textTheme.muted.copyWith(
                                        color: colorScheme.mutedForeground,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Teacher Name
                                    Text(
                                      teacherName,
                                      style: theme.textTheme.muted.copyWith(
                                        color: colorScheme.secondaryForeground,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),

                                if (showAvatar && avatarUrl != null) ...[
                                  const SizedBox(width: 12),
                                  _buildAvatar(colorScheme),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

  Widget _buildAvatar(ShadColorScheme colorScheme) {
    final isNetwork =
        avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://');

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: .05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999),
        child: isNetwork
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.muted,
                  child: Icon(Icons.person, color: colorScheme.mutedForeground),
                ),
              )
            : Image.asset(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: colorScheme.muted,
                  child: Icon(Icons.person, color: colorScheme.mutedForeground),
                ),
              ),
      ),
    );
  }
}
