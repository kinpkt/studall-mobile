import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/theme/theme_extension.dart';

/// A card-style radio button that can be configured like Flutter's built-in Radio.
/// Uses ThemeData TextStyle and ColorScheme from ShadTheme.
///
/// Example:
/// ```dart
/// RadioCard<String>(
///   title: 'สำหรับนักเรียน',
///   description: 'จัดการตารางเรียน ติดตามการบ้าน และรับการแจ้งเตือนเพื่อไม่พลาดทุกคลาสสำคัญ',
///   value: 'student',
///   groupValue: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
///   backgroundImage: 'assets/images/student_bg.png',
/// )
/// ```
class RadioCard<T> extends StatelessWidget {
  /// The title text displayed prominently at the top.
  final String title;

  /// The description text displayed below the title.
  final String description;

  /// The value represented by this radio card.
  final T value;

  /// The currently selected value of the radio group.
  final T? groupValue;

  /// Called when the user selects this radio card.
  final ValueChanged<T?>? onChanged;

  /// Optional background image path (asset or network).
  final String? backgroundImage;

  /// Whether the radio card is enabled. Defaults to true.
  final bool enabled;

  const RadioCard({
    super.key,
    required this.title,
    required this.description,
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.backgroundImage,
    this.enabled = true,
  });

  bool get _isSelected => value == groupValue;
  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (_isSelected)
          Positioned(
            top: -4,
            left: -4,
            right: -4,
            bottom: -4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: colorScheme.ring, width: 2),
              ),
            ),
          ),
        GestureDetector(
          onTap: enabled && onChanged != null ? () => onChanged!(value) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            constraints: const BoxConstraints(minWidth: 394, minHeight: 124),
            decoration: BoxDecoration(
              color: colorScheme.card,
              border: Border.all(color: colorScheme.border, width: 1),
              borderRadius: BorderRadius.circular(24),
              boxShadow: _isSelected ? theme.shadows.sm : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  if (backgroundImage != null) _buildBackgroundImage(),
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

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.h4.copyWith(
                            color: colorScheme.cardForeground,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.muted.copyWith(
                            color: colorScheme.mutedForeground,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                        ),
                      ],
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

    // Check if it's a network image or asset
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
}
