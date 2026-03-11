import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/courses/presentation/providers/course_list_provider.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/course_app_bar.dart';

class CourseDetailLayout extends ConsumerStatefulWidget {
  final String courseId;

  final Widget child;

  const CourseDetailLayout({
    super.key,
    required this.courseId,
    required this.child,
  });

  @override
  ConsumerState<CourseDetailLayout> createState() => _CourseDetailLayoutState();
}

class _CourseDetailLayoutState extends ConsumerState<CourseDetailLayout>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _paths = ['forums', 'tasks', 'notes'];

  int _indexFromPath(String path) {
    if (path.endsWith('/tasks')) return 1;
    if (path.endsWith('/notes')) return 2;
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
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final courseAsync = ref.watch(courseByIdProvider(widget.courseId));

    return Scaffold(
      body: courseAsync.when(
        data: (course) {
          if (course == null) {
            return Center(
              child: Text('ไม่พบรายวิชา', style: theme.textTheme.large),
            );
          }
          return Column(
            children: [
              CourseAppBar(
                course: course,
                tabController: _tabController,
                tabPaths: _paths,
              ),
              Expanded(child: widget.child),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) =>
            Center(child: Text('เกิดข้อผิดพลาด', style: theme.textTheme.large)),
      ),
    );
  }
}
