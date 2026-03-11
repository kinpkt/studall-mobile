import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studall/src/core/services/r2_service.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/data/models/utility_model.dart';
import 'package:studall/src/features/student/data/repositories/utility_firestore_repository.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';

import 'package:studall/src/common_widgets/common_app_bar.dart';

import '../../data/repositories/note_firestore_repository.dart';
import '../providers/student_note_quill_provider.dart';

class NoteQuillScreen extends ConsumerStatefulWidget {
  final NoteModel? note;
  const NoteQuillScreen({super.key, this.note});

  @override
  ConsumerState<NoteQuillScreen> createState() => _NoteQuillScreenState();
}

class _NoteQuillScreenState extends ConsumerState<NoteQuillScreen> {
  late final QuillController _quillController;
  late final TextEditingController _titleController;

  String? _selectedCourseId;
  bool _isPinned = false;
  bool _hasChanges = false;

  String _initialTitle = '';
  String _initialContent = '';
  String? _initialCourseId;
  bool _initialIsPinned = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _initialTitle = widget.note?.title ?? '';

    _selectedCourseId = widget.note?.courseId;
    _initialCourseId = widget.note?.courseId;
    _isPinned = widget.note?.isPinned ?? false;
    _initialIsPinned = widget.note?.isPinned ?? false;

    if (widget.note != null && widget.note!.content.isNotEmpty) {
      try {
        final decodedJson = jsonDecode(widget.note!.content);
        final document = Document.fromJson(decodedJson);
        _quillController = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
        );
        _initialContent = widget.note!.content;
      } catch (e) {
        debugPrint('Error loading note content: $e');
        _quillController = QuillController.basic();
      }
    } else {
      _quillController = QuillController.basic();
    }

    _titleController.addListener(_checkChanges);
    _quillController.document.changes.listen((_) => _checkChanges());
  }

  void _checkChanges() {
    final currentContent = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );
    final changed =
        _titleController.text != _initialTitle ||
        currentContent != _initialContent ||
        _selectedCourseId != _initialCourseId ||
        _isPinned != _initialIsPinned;

    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_checkChanges);
    _quillController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<String?> _uploadFile(String localPath) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final file = File(localPath);
      final fileName =
          'students/${currentUser!.uid}/notes/${DateTime.now().millisecondsSinceEpoch}.png';
      final String fileUrl = await ref
          .read(r2ServiceProvider)
          .uploadFile(file, fileName);
      return fileUrl;
    } catch (e) {
      debugPrint('Error uploading to Cloudflare R2: $e');
      return null;
    }
  }

  Future<void> _pickAndInsertImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final uploadedImageUrl = await _uploadFile(image.path);

      if (mounted) {
        context.pop();
      }

      if (uploadedImageUrl != null) {
        final index = _quillController.selection.baseOffset;
        final length = _quillController.selection.extentOffset - index;
        _quillController.replaceText(
          index,
          length,
          BlockEmbed.image(uploadedImageUrl),
          null,
        );
      } else {
        if (mounted) {
          ShadToaster.of(context).show(
            ShadToast.destructive(
              title: const Text('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ'),
            ),
          );
        }
      }
    }
  }

  Future<void> _saveNote() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final deltaJson = _quillController.document.toDelta().toJson();
    final contentString = jsonEncode(deltaJson);

    final newNote = NoteModel(
      id: widget.note?.id,
      title: _titleController.text.isEmpty ? 'Untitled' : _titleController.text,
      content: contentString,
      courseId: _selectedCourseId,
      isPinned: _isPinned,
    );

    final newUtility = UtilityModel.fromNoteModel(newNote);

    if (widget.note != null) {
      await ref
          .read(noteFirestoreRepositoryProvider)
          .updateNote(currentUser.uid, newNote);
      await ref
          .read(utilityFirestoreRepositoryProvider)
          .updateUtility(currentUser.uid, newUtility);
    } else {
      await ref
          .read(noteFirestoreRepositoryProvider)
          .addNote(currentUser.uid, newNote);
      await ref
          .read(utilityFirestoreRepositoryProvider)
          .addUtility(currentUser.uid, newUtility);
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    if (_selectedCourseId == null) {
      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: const Text('กรุณาเลือกวิชา'),
          description: const Text('คุณยังไม่ได้เลือกวิชาสำหรับบันทึกนี้'),
        ),
      );
      return false;
    }

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadDialog(
            title: const Text('บันทึกการเปลี่ยนแปลง?'),
            description: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'คุณมีการเปลี่ยนแปลงที่ยังไม่ได้บันทึก ต้องการบันทึกก่อนออกหรือไม่?',
              ),
            ),
            actions: [
              ShadButton.outline(
                child: const Text('ไม่บันทึก'),
                onPressed: () => Navigator.of(dialogContext).pop('discard'),
              ),
              ShadButton(
                child: const Text('บันทึก'),
                onPressed: () => Navigator.of(dialogContext).pop('save'),
              ),
            ],
          ),
        );
      },
    );

    if (result == 'save') {
      await _saveNote();
      return true;
    } else if (result == 'discard') {
      return true;
    }
    return false;
  }

  void _deleteNote() {
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadDialog.alert(
            title: const Text('ลบโน้ต'),
            description: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'คุณแน่ใจหรือไม่ว่าต้องการลบโน้ตนี้? การกระทำนี้ไม่สามารถย้อนกลับได้',
              ),
            ),
            actions: [
              ShadButton.outline(
                child: const Text('ยกเลิก'),
                onPressed: () => Navigator.of(dialogContext).pop(false),
              ),
              ShadButton.destructive(
                child: const Text('ลบ'),
                onPressed: () => Navigator.of(dialogContext).pop(true),
              ),
            ],
          ),
        );
      },
    ).then((shouldDelete) async {
      if (shouldDelete == true) {
        final currentUser = FirebaseAuth.instance.currentUser;

        if (currentUser != null && widget.note != null) {
          await ref
              .read(noteFirestoreRepositoryProvider)
              .deleteNote(currentUser.uid, widget.note!.id);
          await ref
              .read(utilityFirestoreRepositoryProvider)
              .deleteUtility(currentUser.uid, widget.note!.id);
        }

        if (context.mounted) context.pop();
      }
    });
  }

  String _getAppBarTitle(AsyncValue<List<dynamic>> coursesValue) {
    if (_selectedCourseId == null) return 'เลือกวิชา';
    return coursesValue.when(
      data: (courses) {
        final course = courses
            .cast<dynamic>()
            .where((c) => c.id == _selectedCourseId)
            .firstOrNull;
        return course?.name ?? 'เลือกวิชา';
      },
      loading: () => '...',
      error: (_, _) => 'เลือกวิชา',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return LogInScreen();

    final ownedCoursesAsyncValue = ref.watch(
      ownedCoursesProvider(currentUser.uid),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.background,
        appBar: CommonAppbar(
          leading: [
            GestureDetector(
              onTap: () async {
                final shouldPop = await _onWillPop();
                if (shouldPop && context.mounted) {
                  context.pop();
                }
              },
              child: Icon(
                PhosphorIconsRegular.arrowLeft,
                color: colorScheme.foreground,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    _showCourseSelector(context, ownedCoursesAsyncValue),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        _getAppBarTitle(ownedCoursesAsyncValue),
                        style: theme.textTheme.h4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      PhosphorIconsRegular.caretDown,
                      size: 16,
                      color: colorScheme.mutedForeground,
                    ),
                  ],
                ),
              ),
            ),
          ],
          actions: [
            _buildIconButton(
              icon: _isPinned
                  ? PhosphorIconsFill.pushPin
                  : PhosphorIconsRegular.pushPin,
              color: _isPinned ? colorScheme.primary : colorScheme.foreground,
              borderColor: colorScheme.border,
              onTap: () {
                setState(() => _isPinned = !_isPinned);
                _checkChanges();
              },
            ),
            const SizedBox(width: 8),
            if (widget.note != null)
              _buildIconButton(
                icon: PhosphorIconsRegular.trash,
                color: colorScheme.destructive,
                borderColor: colorScheme.border,
                onTap: _deleteNote,
              ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _titleController,
                style: theme.textTheme.h4.copyWith(fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'ชื่อหัวเรื่อง...',
                  hintStyle: theme.textTheme.h4.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.mutedForeground,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
            if (widget.note != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.note!.timeDifferenceString,
                    style: theme.textTheme.muted.copyWith(
                      color: colorScheme.mutedForeground,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: QuillEditor.basic(
                  controller: _quillController,
                  config: QuillEditorConfig(
                    placeholder: 'เริ่มพิมพ์ที่นี่...',
                    embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                    customStyles: DefaultStyles(
                      placeHolder: DefaultTextBlockStyle(
                        theme.textTheme.p.copyWith(
                          color: colorScheme.foreground.withValues(alpha: 0.5),
                        ),
                        const HorizontalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null,
                      ),
                      paragraph: DefaultTextBlockStyle(
                        theme.textTheme.p.copyWith(
                          color: colorScheme.foreground,
                        ),
                        const HorizontalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        const VerticalSpacing(0, 0),
                        null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.background,
                border: Border(
                  top: BorderSide(color: colorScheme.border, width: 1),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: QuillSimpleToolbar(
                    controller: _quillController,
                    config: QuillSimpleToolbarConfig(
                      showDividers: true,
                      showFontFamily: false,
                      showSearchButton: false,
                      customButtons: [
                        QuillToolbarCustomButtonOptions(
                          icon: const Icon(Icons.image),
                          onPressed: _pickAndInsertImage,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(child: Icon(icon, color: color, size: 24)),
      ),
    );
  }

  void _showCourseSelector(
    BuildContext context,
    AsyncValue<List<dynamic>> coursesValue,
  ) {
    coursesValue.whenData((courses) {
      final theme = ShadTheme.of(context);
      showModalBottomSheet(
        context: context,
        backgroundColor: theme.colorScheme.card,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('เลือกวิชา', style: theme.textTheme.h4),
                ),
                ...courses.cast<dynamic>().map((course) {
                  return ListTile(
                    leading: Icon(
                      _selectedCourseId == course.id
                          ? PhosphorIconsFill.checkCircle
                          : PhosphorIconsRegular.circle,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(course.name, style: theme.textTheme.p),
                    onTap: () {
                      setState(() => _selectedCourseId = course.id);
                      _checkChanges();
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          );
        },
      );
    });
  }
}
