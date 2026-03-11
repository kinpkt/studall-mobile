import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:studall/src/core/theme/theme_extension.dart';

import '../../data/models/note_model.dart';

class NotesListTile extends StatelessWidget {
  final NoteModel note;
  final String? courseName;

  const NotesListTile({super.key, required this.note, this.courseName});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => context.push('/student/notes/editor', extra: note),
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
                color: colorScheme.custom['green'],
                borderRadius: BorderRadius.circular(12),
                boxShadow: theme.shadows.sm,
              ),
              child: const Center(
                child: Icon(
                  PhosphorIconsRegular.notebook,
                  color: Colors.white,
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
                    note.title,
                    style: textTheme.custom['medium']?.copyWith(
                      color: colorScheme.foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (courseName != null) ...[
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            courseName!,
                            style: textTheme.muted.copyWith(
                              color: colorScheme.mutedForeground,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        note.timeDifferenceString,
                        style: textTheme.muted.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (note.isPinned)
              SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    PhosphorIconsFill.pushPin,
                    color: colorScheme.mutedForeground,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
