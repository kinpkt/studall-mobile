import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StudentTasksLayoutScreen extends StatefulWidget {
  final Widget child;

  const StudentTasksLayoutScreen({super.key, required this.child});

  @override
  State<StudentTasksLayoutScreen> createState() =>
      _StudentTasksLayoutScreenState();
}

class _StudentTasksLayoutScreenState extends State<StudentTasksLayoutScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _paths = ['assigned', 'overdue', 'done'];

  int _indexFromPath(String path) {
    if (path.endsWith('/overdue')) return 1;
    if (path.endsWith('/done')) return 2;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final path = GoRouterState.of(context).uri.path;
    final index = _indexFromPath(path);
    if (_tabController.index != index) {
      _tabController.index = index;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ShadTheme.of(context).colorScheme.background,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            onTap: (index) => context.go('/student/tasks/${_paths[index]}'),
            tabs: const [
              Tab(text: 'มอบหมายแล้ว'),
              Tab(text: 'เลยกำหนด'),
              Tab(text: 'เสร็จสิ้น'),
            ],
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
