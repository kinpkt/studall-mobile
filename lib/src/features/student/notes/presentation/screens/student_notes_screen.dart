import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
  String? _selectedCourseId;
  Stream<List<NoteModel>>? _ownedNotesStream;
  Stream<List<CourseModel>>? _ownedCoursesStream;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _ownedNotesStream = ref
            .read(noteFirestoreRepositoryProvider)
            .getNotesByUserId(currentUser.uid);

        _ownedCoursesStream = ref
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

    // Ensure streams aren't null just in case build runs before initState finishes
    if (_ownedNotesStream == null || _ownedCoursesStream == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: colorScheme.background,
      child: Column(
        children: [
          _buildSearchBar(context, _ownedCoursesStream!),
          if (_selectedCourseId != null)
            _buildActiveFilterText(context, _ownedCoursesStream!),
          Expanded(
            child: StreamBuilder<List<CourseModel>>(
              stream: _ownedCoursesStream,
              builder: (context, coursesSnapshot) {
                final courses = coursesSnapshot.data ?? [];
                final courseMap = {for (final c in courses) c.id: c.name};

                return StreamBuilder<List<NoteModel>>(
                  stream: _ownedNotesStream,
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
                              .where(
                                (note) => note.courseId == _selectedCourseId,
                              )
                              .toList()
                        : allNotes;

                    if (notes.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'เริ่มต้นบันทึกของคุณ',
                            style: theme.textTheme.p.copyWith(
                              color: colorScheme.mutedForeground,
                            ),
                          ),
                          ShadButton.ghost(
                            onPressed: () =>
                                context.push('/student/notes/editor'),
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

                    // Group unpinned notes by courseId
                    final grouped = <String?, List<NoteModel>>{};
                    for (final note in unpinnedNotes) {
                      grouped.putIfAbsent(note.courseId, () => []).add(note);
                    }

                    // Sort: notes with courseId first, then null
                    final sortedKeys = grouped.keys.toList()
                      ..sort((a, b) {
                        if (a == null) return 1;
                        if (b == null) return -1;
                        return (courseMap[a] ?? '').compareTo(
                          courseMap[b] ?? '',
                        );
                      });

                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (pinnedNotes.isNotEmpty)
                          _NotesSection(
                            title: 'ปักหมุด',
                            notes: pinnedNotes,
                            courseMap: courseMap,
                          ),
                        for (final courseId in sortedKeys)
                          _NotesSection(
                            title: courseId != null
                                ? (courseMap[courseId] ?? courseId)
                                : 'ไม่มีรายวิชา',
                            notes: grouped[courseId]!,
                            courseMap: courseMap,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Updated to accept the stream and use StreamBuilder
  Widget _buildActiveFilterText(
    BuildContext context,
    Stream<List<CourseModel>> coursesStream,
  ) {
    final theme = ShadTheme.of(context);

    return StreamBuilder<List<CourseModel>>(
      stream: coursesStream,
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

  // Updated to use StreamBuilder
  Widget _buildSearchBar(
    BuildContext context,
    Stream<List<CourseModel>> coursesStream,
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
        trailing: StreamBuilder<List<CourseModel>>(
          stream: coursesStream,
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
                    snapshot.connectionState == ConnectionState.active)
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
                  PhosphorIconsRegular.sliders,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NotesSection extends StatefulWidget {
  final String title;
  final List<NoteModel> notes;
  final Map<String, String> courseMap;
  final int previewCount;

  const _NotesSection({
    required this.title,
    required this.notes,
    required this.courseMap,
    this.previewCount = 3,
  });

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
        : widget.notes.take(widget.previewCount).toList();
    final hasMore = widget.notes.length > widget.previewCount;

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
              Text(
                widget.notes.length.toString(),
                style: theme.textTheme.custom['medium']?.copyWith(
                  color: colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        ...displayNotes.map(
          (note) => NotesListTile(
            note: note,
            courseName: note.courseId != null
                ? widget.courseMap[note.courseId]
                : null,
          ),
        ),
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
