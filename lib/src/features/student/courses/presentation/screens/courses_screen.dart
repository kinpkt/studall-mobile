import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/add_edit_course_modal.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  void _showAddCourseModal(BuildContext context) {
    showShadDialog(
      context: context,
      builder: (context) {
        return AddEditCourseModal();
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('วิชา', style: theme.textTheme.h4,),
        actions: [
          IconButton(
            onPressed: () {
              _showAddCourseModal(context);
            },
            icon: Icon(PhosphorIconsBold.plus)
          )
        ],
      ),
      body: Container(), // TODO: Implement courses list
    );
  }
}
