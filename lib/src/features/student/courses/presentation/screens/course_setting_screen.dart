import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/common_widgets/app_list_tile.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:studall/src/features/student/courses/presentation/controllers/course_setting_controller.dart';
import 'package:studall/src/features/student/courses/presentation/providers/course_list_provider.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/schedule_dialog.dart';

class CourseSettingScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseSettingScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseSettingScreen> createState() =>
      _CourseSettingScreenState();
}

class _CourseSettingScreenState extends ConsumerState<CourseSettingScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _teacherController;
  late List<CourseScheduleModel> _schedules;

  CourseModel? _originalCourse;
  bool _initialized = false;
  bool _nameEnabled = false;
  bool _descriptionEnabled = false;

  bool get _hasChanges {
    if (_originalCourse == null) return false;
    final o = _originalCourse!;
    return _nameController.text.trim() != o.name ||
        _descriptionController.text.trim() != (o.description ?? '') ||
        _teacherController.text.trim() != (o.teacherName ?? '') ||
        !_schedulesEqual(_schedules, o.schedule);
  }

  bool _schedulesEqual(
    List<CourseScheduleModel> a,
    List<CourseScheduleModel> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _initFromCourse(CourseModel course) {
    if (_initialized) return;
    _initialized = true;
    _originalCourse = course;
    _nameController = TextEditingController(text: course.name);
    _descriptionController = TextEditingController(
      text: course.description ?? '',
    );
    _teacherController = TextEditingController(text: course.teacherName ?? '');
    _schedules = [...course.schedule];

    _nameController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (_initialized) {
      _nameController.dispose();
      _descriptionController.dispose();
      _teacherController.dispose();
    }
    super.dispose();
  }

  void _removeSchedule(int index) => setState(() => _schedules.removeAt(index));

  void _openAddScheduleDialog() {
    ScheduleDialog.show(
      context,
      onSave: (s) => setState(() => _schedules.add(s)),
    );
  }

  void _openEditScheduleDialog(int index, CourseScheduleModel schedule) {
    ScheduleDialog.show(
      context,
      schedule: schedule,
      onSave: (updated) => setState(() => _schedules[index] = updated),
    );
  }

  void _saveCourse() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final original = _originalCourse;
    if (original == null) return;

    final updatedCourse = CourseModel(
      id: original.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      teacherName: _teacherController.text.trim().isEmpty
          ? null
          : _teacherController.text.trim(),
      schedule: _schedules,
      createdAt: original.createdAt,
      isActive: original.isActive,
    );

    ref
        .read(courseSettingControllerProvider.notifier)
        .updateCourse(updatedCourse);
  }

  void _showArchiveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShadDialog.alert(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text('ต้องการจัดเก็บวิชานี้หรือไม่?'),
          ),
          description: const Text(
            'วิชาจะถูกย้ายไปยังรายการจัดเก็บ และจะไม่แสดงในรายวิชาปัจจุบัน',
          ),
          actions: [
            ShadButton.secondary(
              onPressed: () => ctx.pop(),
              child: const Text('ยกเลิก'),
            ),
            ShadButton.destructive(
              onPressed: () {
                ctx.pop();
                ref
                    .read(courseSettingControllerProvider.notifier)
                    .archiveCourse(widget.courseId);
              },
              child: const Text('จัดเก็บวิชา'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShadDialog.alert(
          title: const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Text('ต้องการลบวิชานี้หรือไม่?'),
          ),
          description: const Text(
            'วิชาและข้อมูลทั้งหมดจะถูกลบอย่างถาวร การกระทำนี้ไม่สามารถย้อนกลับได้',
          ),
          actions: [
            ShadButton.secondary(
              onPressed: () => ctx.pop(),
              child: const Text('ยกเลิก'),
            ),
            ShadButton.destructive(
              onPressed: () {
                ctx.pop();
                ref
                    .read(courseSettingControllerProvider.notifier)
                    .deleteCourse(widget.courseId);
                context.go('/student/courses');
              },
              child: const Text('ลบวิชา'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherProfileSettingSection(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'ผู้สอน',
                style: textTheme.custom['medium']?.copyWith(
                  color: colorScheme.foreground,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.muted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AppListTile(
              title: _teacherController.text.trim().isEmpty
                  ? 'ไม่ระบุผู้สอน'
                  : _teacherController.text.trim(),
              titleStyle: textTheme.custom['medium']?.copyWith(
                color: colorScheme.foreground,
              ),
              leading: ShadAvatar(
                null,
                size: const Size.square(40),
                backgroundColor: colorScheme.background,
                placeholder: Icon(
                  PhosphorIconsRegular.user,
                  color: colorScheme.foreground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ShadForm(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ShadInputFormField(
              // enabled: _nameEnabled,
              id: 'courseName',
              controller: _nameController,
              label: const Text('ชื่อวิชา'),
              placeholder: const Text('เช่น สังคมศึกษา, ระบบปฏิบัติการ'),
              validator: (value) =>
                  value.trim().isEmpty ? 'กรุณากรอกชื่อวิชา' : null,
              trailing: GestureDetector(
                onTap: () => setState(() => _nameEnabled = !_nameEnabled),
                child: Icon(
                  PhosphorIconsRegular.pencilSimpleLine,
                  size: 24,
                  color: colorScheme.mutedForeground,
                ),
              ),
            ),
            const SizedBox(height: 16),

            ShadInputFormField(
              // enabled: _descriptionEnabled,
              id: 'description',
              controller: _descriptionController,
              label: const Text('คำอธิบาย'),
              placeholder: const Text(
                'เช่น หมู่ 11, ห้อง 125, อาคาร 10 ชั้น 3',
              ),
              trailing: GestureDetector(
                onTap: () =>
                    setState(() => _descriptionEnabled = !_descriptionEnabled),
                child: Icon(
                  PhosphorIconsRegular.pencilSimpleLine,
                  size: 24,
                  color: colorScheme.mutedForeground,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ShadInputFormField(
            //   id: 'teacherName',
            //   controller: _teacherController,
            //   label: const Text('ชื่อผู้สอน'),
            //   placeholder: const Text('เช่น ศ. ดร. งานเยอะ ได้นอนน้อย'),
            // ),
            // const SizedBox(height: 16),
            Text(
              'เวลาเรียน',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.foreground,
              ),
            ),
            const SizedBox(height: 8),
            ..._schedules.asMap().entries.map(
              (entry) => _buildScheduleItem(context, entry.key, entry.value),
            ),
            ShadButton.secondary(
              onPressed: _openAddScheduleDialog,
              child: const Text('เพิ่มเวลาเรียน'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    int index,
    CourseScheduleModel schedule,
  ) {
    final theme = ShadTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${dayName(schedule.day)} '
                      '${schedule.startTime?.format(context) ?? ''} - '
                      '${schedule.endTime?.format(context) ?? ''}'
                      '${schedule.location != null ? ', ${schedule.location}' : ''}',
                      style: theme.textTheme.custom['medium']?.copyWith(
                        color: theme.colorScheme.foreground,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _openEditScheduleDialog(index, schedule),
                    child: Icon(
                      PhosphorIconsRegular.pencilSimpleLine,
                      size: 24,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ShadIconButton.ghost(
            width: 44,
            height: 44,
            onPressed: () => _removeSchedule(index),
            icon: Icon(
              PhosphorIconsRegular.trash,
              size: 24,
              color: theme.colorScheme.destructive,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionSection(BuildContext context) {
    final theme = ShadTheme.of(context);
    final controllerState = ref.watch(courseSettingControllerProvider);
    final isLoading = controllerState.isLoading;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_hasChanges)
            ShadButton(
              onPressed: isLoading ? null : _saveCourse,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('บันทึกการเปลี่ยนแปลง'),
            ),
          ShadButton.ghost(
            onPressed: isLoading ? null : _showArchiveConfirmationDialog,
            child: Text(
              'จัดเก็บวิชาเรียน',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
          ),
          ShadButton.ghost(
            onPressed: isLoading ? null : _showDeleteConfirmationDialog,
            child: Text(
              'ลบวิชาเรียน',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.destructive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String? courseName) {
    return CommonAppbar(
      title: 'ตั้งค่า',
      subtitle: courseName,
      leading: [
        ShadIconButton.ghost(
          decoration: ShadDecoration(shape: BoxShape.circle),
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => context.pop(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseAsync = ref.watch(courseByIdProvider(widget.courseId));
    final theme = ShadTheme.of(context);

    ref.listen(courseSettingControllerProvider, (prev, next) {
      if (prev?.isLoading == true && next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: ${next.error}')),
        );
      }
      if (prev?.isLoading == true && next.hasValue && !next.isLoading) {
        setState(() {
          _originalCourse = CourseModel(
            id: _originalCourse!.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            teacherName: _teacherController.text.trim().isEmpty
                ? null
                : _teacherController.text.trim(),
            schedule: [..._schedules],
            createdAt: _originalCourse!.createdAt,
            isActive: _originalCourse!.isActive,
          );
        });
        ref.invalidate(courseByIdProvider(widget.courseId));
        ref.invalidate(userCoursesProvider);
      }
    });

    return courseAsync.when(
      data: (course) {
        if (course == null) {
          return Scaffold(
            appBar: _buildAppBar(context, null),
            body: Center(
              child: Text('ไม่พบรายวิชา', style: theme.textTheme.large),
            ),
          );
        }

        _initFromCourse(course);

        return Scaffold(
          appBar: _buildAppBar(context, course.name),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildTeacherProfileSettingSection(context),
                _buildFormSection(context),
                _buildBottomActionSection(context),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: _buildAppBar(context, null),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: _buildAppBar(context, null),
        body: Center(
          child: Text('เกิดข้อผิดพลาด: $e', style: theme.textTheme.large),
        ),
      ),
    );
  }
}
