import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/tasks/presentation/widgets/to_do_list_tile.dart';
import '../../../courses/data/models/course_model.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_type.dart';
import '../widgets/tasks_tab_bar.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sandbox area for defining hardcoded datasources
    CourseModel demoCourse = CourseModel(courseId: '01418342-65', name: 'Mobile Application Design and Development', credit: 3);
    TaskModel demoTask = TaskModel(title: 'Ass09: Asynchronous Programming', dueDate: DateTime(2026, 2, 26, 23, 59), type: TaskType.assignment, course: demoCourse);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: ShadTheme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              const TasksTabBar(),
              // TO-DO: group ListTiles into groups based on their deadlines
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        ToDoListTile(task: demoTask)
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
