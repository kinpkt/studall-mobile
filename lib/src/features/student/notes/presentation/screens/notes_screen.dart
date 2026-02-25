import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/notes/data/models/note_model.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_list_tile.dart';
import 'package:studall/src/features/student/notes/presentation/widgets/notes_tab_bar.dart';
import 'package:uuid/uuid.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // Sandbox area for defining hardcoded datasources
    // final CourseModel demoCourse = CourseModel(courseId: '01418232', name: 'Algorithm Design and Analysis', credit: 3);
    // final NoteModel demoNote = NoteModel(Uuid().v7(), 'Dynamic Programming Examples', demoCourse, DateTime.now());
    // final NoteModel demoNote2 = NoteModel(Uuid().v7(), 'Master Theorem Proof', demoCourse, DateTime(2025, 12, 26));
    // final NoteModel demoNote3 = NoteModel(Uuid().v7(), 'Merge Sort Pseudocode', demoCourse, DateTime(2026, 2, 2));

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('ล่าสุด', style: theme.textTheme.h4),
                        ),
                        // NotesListTile(note: demoNote,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('ปักหมุด', style: theme.textTheme.h4),
                        ),
                        // NotesListTile(note: demoNote2, isPinned: true,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text('ทั่วไป', style: theme.textTheme.h4),
                        ),
                        // NotesListTile(note: demoNote3,),
                      ],
                    ),
                    // Center(child: Text("หน้ามอบหมายแล้ว")),
                    Center(child: Text("หน้าเลยกำหนด")),
                    Center(child: Text("หน้าเสร็จสิ้น")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
