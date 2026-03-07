import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';
import 'package:studall/src/features/student/notes/data/repositories/note_firestore_repository.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_list_tile.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';

class StudentNotesScreen extends ConsumerStatefulWidget {
  const StudentNotesScreen({super.key});

  @override
  ConsumerState<StudentNotesScreen> createState() => _StudentNotesScreenState();
}

class _StudentNotesScreenState extends ConsumerState<StudentNotesScreen> {
  String? _selectedCourseId; // null = show all notes, non-null = filter by courseId
  Future<List<NoteModel>>? _ownedNotesFuture;
  Future<List<CourseModel>>? _ownedCoursesFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _ownedNotesFuture = ref
          .read(noteFirestoreRepositoryProvider)
          .getNotesByUserId(currentUser.uid);

        _ownedCoursesFuture = ref
          .read(courseFirestoreRepositoryProvider)
          .getCoursesByUserId(currentUser.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const LogInScreen();
    }

    // Ensure futures aren't null just in case build runs before initState finishes
    if (_ownedNotesFuture == null || _ownedCoursesFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          // Add a refresh indicator at the top so users can pull to refresh manually
          _buildSearchBar(context, _ownedCoursesFuture!),
          if (_selectedCourseId != null) _buildActiveFilterText(context),
          Expanded(
            // Wrap the list in a RefreshIndicator for manual pull-to-refresh
            child: RefreshIndicator(
              onRefresh: () async {
                _fetchData();
                // Wait for the new future to complete before stopping the spinner
                await _ownedNotesFuture;
              },
              child: FutureBuilder<List<NoteModel>>(
                future: _ownedNotesFuture,
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

                  final notes = _selectedCourseId != null
                      ? allNotes
                      .where((note) => note.courseId == _selectedCourseId)
                      .toList()
                      : allNotes;

                  if (notes.isEmpty) {
                    return ListView(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                        Center(child: Text('ยังไม่มีโน้ต', style: theme.textTheme.h3)),
                      ],
                    );
                  }

                  final pinnedNotes = notes.where((note) => note.isPinned).toList();
                  final unpinnedNotes = notes.where((note) => !note.isPinned).toList();

                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      if (pinnedNotes.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text('ปักหมุด', style: theme.textTheme.h4),
                        ),
                        ...pinnedNotes.map((note) => NotesListTile(note: note)),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text('ทั่วไป', style: theme.textTheme.h4),
                      ),
                      ...unpinnedNotes.map((note) => NotesListTile(note: note)),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterText(BuildContext context) {
    final theme = ShadTheme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder<List<CourseModel>>(
      future: ref
          .read(courseFirestoreRepositoryProvider)
          .getCoursesByUserId(currentUser?.uid ?? ''),
      builder: (context, snapshot) {
        final courses = snapshot.data ?? [];
        final courseName = courses
            .where((c) => c.id == _selectedCourseId)
            .map((c) => c.name)
            .firstOrNull;

        if (courseName == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => setState(() => _selectedCourseId = null),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'กรองโดย: $courseName',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'ล้างตัวกรอง',
                    style: theme.textTheme.small.copyWith(
                      color: theme.colorScheme.custom['info'],
                      decoration: TextDecoration.underline,
                      decorationColor: theme.colorScheme.custom['info']!,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    Future<List<CourseModel>> coursesFuture,
  ) {
    final theme = ShadTheme.of(context);
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ShadInput(
        decoration: const ShadDecoration(
          secondaryFocusedBorder: ShadBorder.none,
        ),
        placeholder: const Text('ค้นหาโน้ต'),
        leading: Icon(PhosphorIconsRegular.magnifyingGlass, size: 20),
        trailing: FutureBuilder<List<CourseModel>>(
          future: coursesFuture,
          builder: (context, snapshot) {
            final courses = snapshot.data ?? [];

            return MenuAnchor(
              menuChildren: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    'กรองโดยวิชา',
                    style: textTheme.small.copyWith(
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ),
                MenuItemButton(
                  leadingIcon: _selectedCourseId == null
                      ? Icon(PhosphorIconsRegular.check, size: 16)
                      : const SizedBox(width: 16),
                  onPressed: () => setState(() => _selectedCourseId = null),
                  child: Text('ทั้งหมด', style: theme.textTheme.p),
                ),
                ...courses.map((course) {
                  return MenuItemButton(
                    leadingIcon: _selectedCourseId == course.id
                        ? Icon(PhosphorIconsRegular.check, size: 16)
                        : const SizedBox(width: 16),
                    onPressed: () =>
                        setState(() => _selectedCourseId = course.id),
                    child: Text(course.name, style: theme.textTheme.p),
                  );
                }),
                if (courses.isEmpty &&
                    snapshot.connectionState == ConnectionState.done)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Text(
                      'ไม่มีวิชา',
                      style: textTheme.small.copyWith(
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ),
              ],
              builder: (context, controller, child) => GestureDetector(
                onTap: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                child: Icon(
                  _selectedCourseId != null
                      ? PhosphorIconsFill.funnel
                      : PhosphorIconsRegular.sliders,
                  size: 20,
                  color: _selectedCourseId != null
                      ? theme.colorScheme.primary
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
