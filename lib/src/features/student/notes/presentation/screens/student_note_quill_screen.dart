import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:studall/src/core/services/r2_service.dart';
import 'package:studall/src/features/auth/presentation/screens/log_in_screen.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';

import '../../../courses/data/models/course_model.dart';
import '../../data/repositories/note_firestore_repository.dart';

final ownedCoursesProvider = FutureProvider.autoDispose.family<List<CourseModel>, String>((ref, userId) {
  return ref.watch(courseFirestoreRepositoryProvider).getCoursesByUserId(userId);
});

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

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note?.title ?? '');

    _selectedCourseId = widget.note?.courseId;

    if (widget.note != null && widget.note!.content.isNotEmpty) {
      try {
        final decodedJson = jsonDecode(widget.note!.content);

        final document = Document.fromJson(decodedJson);

        _quillController = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
      catch (e) {
        debugPrint('Error loading note content: $e');
        _quillController = QuillController.basic();
      }
    }
    else {
      _quillController = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<String?> _uploadFile(String localPath) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      final file = File(localPath);
      final fileName = 'students/${currentUser!.uid}/notes/${DateTime.now().millisecondsSinceEpoch}.png';

      final String fileUrl = await ref.read(r2ServiceProvider).uploadFile(file, fileName);

      return fileUrl;
    }
    catch (e) {
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
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final uploadedImageUrl = await _uploadFile(image.path);

      if (mounted) {
        Navigator.of(context).pop();
      }

      if (uploadedImageUrl != null) {
        final index = _quillController.selection.baseOffset;
        final length = _quillController.selection.extentOffset-index;

        _quillController.replaceText(
          index,
          length,
          BlockEmbed.image(uploadedImageUrl),
          null,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปโหลดรูปภาพ')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null)
      return LogInScreen();

    final ownedCoursesAsyncValue = ref.watch(ownedCoursesProvider(currentUser.uid));
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.foreground),
        title: Text('จดโน้ต', style: theme.textTheme.h4),
        actions: [
          ShadButton.ghost(
            onPressed: () async {
              final deltaJson = _quillController.document.toDelta().toJson();

              final contentString = jsonEncode(deltaJson);

              final newNote = NoteModel(
                id: widget.note?.id,
                title: _titleController.text == '' ? 'Untitled' : _titleController.text,
                content: contentString,
                userId: currentUser.uid,
                courseId: _selectedCourseId,
              );

              if (widget.note != null)
                await ref.read(noteFirestoreRepositoryProvider).updateNote(currentUser.uid, newNote);
              else
                await ref.read(noteFirestoreRepositoryProvider).addNote(currentUser.uid, newNote);

              if (mounted)
                Navigator.pop(context);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
      body: Column(
        children: [
          ShadInput(
            placeholder: Text('ชื่อหัวเรื่อง...'),
            controller: _titleController,
          ),
          ownedCoursesAsyncValue.when(
            data: (courses) {
              return SizedBox(
                width: double.infinity,
                child: ShadSelect<String>(
                  placeholder: Text('เลือกวิชา'),
                  initialValue: _selectedCourseId,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCourseId = value;
                      });
                    }
                  },
                  options: courses.map((course) {
                    return ShadOption(
                      value: course.id,
                      child: Text(course.name),
                    );
                  }).toList(),
                  selectedOptionBuilder: (context, value) {
                    final selectedCourse = courses.firstWhere(
                      (c) => c.id == value,
                      orElse: () => courses.first,
                    );
                    return Text(selectedCourse.name);
                  },
                )
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Text('กำลังโหลดวิชา...'),
            ),
            error: (error, stackTrace) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('เกิดข้อผิดพลาด: $error'),
            ),
          ),
          QuillSimpleToolbar(
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
          Divider(color: theme.colorScheme.border, height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: QuillEditor.basic(
                controller: _quillController,
                config: QuillEditorConfig(
                  placeholder: 'เริ่มพิมพ์ที่นี่...',
                  embedBuilders: FlutterQuillEmbeds.editorBuilders(),
                  customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                      theme.textTheme.p.copyWith(
                        color: theme.colorScheme.foreground,
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
        ],
      ),
    );
  }
}