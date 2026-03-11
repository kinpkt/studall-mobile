import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';
import 'package:studall/src/features/student/notes/data/repositories/note_firestore_repository.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_list_tile.dart';

class CourseNotesScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseNotesScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseNotesScreen> createState() => _CourseNotesScreenState();
}

class _CourseNotesScreenState extends ConsumerState<CourseNotesScreen> {
  Stream<List<NoteModel>>? _notesStream;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _notesStream = ref
          .read(noteFirestoreRepositoryProvider)
          .getNotesByUserId(currentUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return const LogInScreen();
    if (_notesStream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          _buildSearchBar(context),
          Expanded(
            child: StreamBuilder<List<NoteModel>>(
              stream: _notesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                  );
                }

                final allNotes = snapshot.data ?? [];
                final notes = allNotes
                    .where((note) => note.courseId == widget.courseId)
                    .toList();

                if (notes.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'ยังไม่มีบันทึกในรายวิชานี้',
                        style: theme.textTheme.p.copyWith(
                          color: colorScheme.mutedForeground,
                        ),
                      ),
                      ShadButton.ghost(
                        onPressed: () => context.push('/student/notes/editor'),
                        child: Text(
                          'สร้างบันทึกใหม่ที่นี่',
                          style: theme.textTheme.p.copyWith(
                            color: colorScheme.custom['info']!,
                            fontWeight: FontWeight.w500,
                            decorationColor: colorScheme.custom['info']!,
                          ),
                        ),
                      ),
                    ],
                  );
                }

                final pinnedNotes = notes
                    .where((note) => note.isPinned)
                    .toList();
                final unpinnedNotes = notes
                    .where((note) => !note.isPinned)
                    .toList();

                return ListView(
                  padding: EdgeInsets.zero,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (pinnedNotes.isNotEmpty)
                      _NotesSection(title: 'ปักหมุด', notes: pinnedNotes),
                    if (unpinnedNotes.isNotEmpty)
                      _NotesSection(title: 'บันทึก', notes: unpinnedNotes),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ShadInput(
        decoration: const ShadDecoration(
          secondaryFocusedBorder: ShadBorder.none,
        ),
        placeholder: const Text('ค้นหาโน้ต'),
        leading: Icon(PhosphorIconsRegular.magnifyingGlass, size: 20),
      ),
    );
  }
}

class _NotesSection extends StatefulWidget {
  final String title;
  final List<NoteModel> notes;

  static const int _previewCount = 3;

  const _NotesSection({required this.title, required this.notes});

  @override
  State<_NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<_NotesSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    final displayNotes = _showAll
        ? widget.notes
        : widget.notes.take(_NotesSection._previewCount).toList();
    final hasMore = widget.notes.length > _NotesSection._previewCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: theme.textTheme.custom['medium'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.notes.length.toString(),
                  style: theme.textTheme.custom['medium']?.copyWith(
                    color: colorScheme.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
        ...displayNotes.map((note) => NotesListTile(note: note)),
        if (hasMore)
          ShadButton.ghost(
            onPressed: () => setState(() => _showAll = !_showAll),
            child: Text(
              _showAll ? 'ซ่อน' : 'ดูเพิ่ม',
              style: theme.textTheme.small.copyWith(
                color: colorScheme.mutedForeground,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.mutedForeground,
              ),
            ),
          ),
      ],
    );
  }
}
