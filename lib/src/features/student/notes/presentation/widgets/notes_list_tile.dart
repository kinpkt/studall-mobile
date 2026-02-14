import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../data/models/note_model.dart';

class NotesListTile extends StatelessWidget {
  final NoteModel note;
  final bool isPinned;

  const NotesListTile({super.key, required this.note, this.isPinned = false});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Material(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.custom['green'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            PhosphorIconsRegular.notebook,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(note.name, style: theme.textTheme.list,),
        subtitle: Text(
          note.course.name != null ? '${note.course.name} (${note.timeDifferenceString})' :
          '(${note.timeDifferenceString})', style: theme.textTheme.muted),
        trailing: isPinned ? Icon(
          PhosphorIconsFill.pushPin,
          color: Colors.grey[300],
          size: 18,
        ) : null,
      ),
    );
  }
}
