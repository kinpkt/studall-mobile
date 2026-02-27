import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';
import 'package:studall/src/features/student/notes/data/repositories/note_firestore_repository.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_list_tile.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_tab_bar.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return LogInScreen();
    }

    final ownedNotes = ref.watch(noteFirestoreRepositoryProvider).getNotesByUserId(currentUser.uid);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              const NotesTabBar(),
              SizedBox(height: 8,),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<NoteModel>>(
                      future: ownedNotes,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                        }

                        final notes = snapshot.data ?? [];

                        if (notes.isEmpty) {
                          return const Center(child: Text('ยังไม่มีโน้ต'));
                        }

                        final pinnedNotes = notes.where((note) => note.isPinned).toList();

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text('ล่าสุด', style: theme.textTheme.h4),
                              ),
                              // TODO: Filter notes for 'ล่าสุด'

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text('ปักหมุด', style: theme.textTheme.h4),
                              ),
                              ...pinnedNotes.map((note) => NotesListTile(note: note)),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text('ทั่วไป', style: theme.textTheme.h4),
                              ),
                              ...notes.map((note) => NotesListTile(note: note)),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
