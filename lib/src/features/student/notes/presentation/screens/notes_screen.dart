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
    // Sandbox area for defining hardcoded datasources
    final CourseModel demoCourse = CourseModel(courseId: '01418232', name: 'Algorithm Design and Analysis', credit: 3);
    final NoteModel demoNote = NoteModel(Uuid().v7(), 'Master Theorem Proof', demoCourse);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              const NotesTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(

                      children: [
                        NotesListTile(note: demoNote,)
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
