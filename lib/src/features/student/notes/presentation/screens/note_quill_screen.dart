import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteQuillScreen extends StatefulWidget {
  const NoteQuillScreen({super.key});

  @override
  State<NoteQuillScreen> createState() => _NoteQuillScreenState();
}

class _NoteQuillScreenState extends State<NoteQuillScreen> {
  late final QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.foreground),
        title: Text('จดโน้ต', style: theme.textTheme.h4),
        actions: [
          ShadButton.ghost(
            onPressed: () {
              final contentJson = _controller.document.toDelta().toJson();
              print(contentJson);
            },
            child: const Text('บันทึก'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. The Toolbar (Updated syntax)
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(
              showDividers: true,
              showFontFamily: false,
              showSearchButton: false,
            ),
          ),

          Divider(color: theme.colorScheme.border, height: 1),

          // 2. The Editor (Updated syntax)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: QuillEditor.basic(
                controller: _controller,
                config: QuillEditorConfig(
                  placeholder: 'เริ่มพิมพ์ที่นี่...',
                  customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                      theme.textTheme.p,
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