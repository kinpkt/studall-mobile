import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';
import 'package:studall/src/features/student/notes/data/repositories/note_firestore_repository.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_list_tile.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_tab_bar.dart';

class StudentNotesScreen extends ConsumerWidget {
  const StudentNotesScreen({super.key});

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ShadInput(
        decoration: const ShadDecoration(
          secondaryFocusedBorder: ShadBorder.none,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        placeholder: const Text('ค้นหาโน้ต'),
        leading: Icon(PhosphorIconsRegular.magnifyingGlass, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return LogInScreen();
    }

    final ownedNotes = ref
        .watch(noteFirestoreRepositoryProvider)
        .getNotesByUserId(currentUser.uid);

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: FutureBuilder<List<NoteModel>>(
              future: ownedNotes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
            
                if (snapshot.hasError) {
                  return Center(
                    child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  );
                }
            
                final notes = snapshot.data ?? [];
            
                if (notes.isEmpty) {
                  return const Center(child: Text('ยังไม่มีโน้ต'));
                }
            
                // final pinnedNotes = notes
                //     .where((note) => note.isPinned)
                //     .toList();
            
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text('ล่าสุด', style: theme.textTheme.h4),
                      ),
            
                      // TODO: Filter notes for 'ล่าสุด'
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text('ปักหมุด', style: theme.textTheme.h4),
                      ),
                      // ...pinnedNotes.map(
                      //   (note) => NotesListTile(note: note),
                      // ),
            
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text('ทั่วไป', style: theme.textTheme.h4),
                      ),
                      // ...notes.map((note) => NotesListTile(note: note)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
