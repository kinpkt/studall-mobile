import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/schedule_dialog.dart';

class AddEditCourseModal extends StatefulWidget {
  final CourseModel? course;
  final void Function(CourseModel) onSave;

  const AddEditCourseModal({super.key, this.course, required this.onSave});

  @override
  State<AddEditCourseModal> createState() => _AddEditCourseModalState();
}

class _AddEditCourseModalState extends State<AddEditCourseModal> {
  final _formKey = GlobalKey<ShadFormState>();
  late final _nameController = TextEditingController(
    text: widget.course?.name ?? '',
  );
  late final _descriptionController = TextEditingController(
    text: widget.course?.description ?? '',
  );
  late final _teacherController = TextEditingController(
    text: widget.course?.teacherName ?? '',
  );

  late final List<CourseScheduleModel> _schedules = [
    ...?widget.course?.schedule,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _teacherController.dispose();
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

    final course = CourseModel(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      teacherName: _teacherController.text.trim().isEmpty
          ? null
          : _teacherController.text.trim(),
      isActive: true,
      schedule: _schedules,
    );

    widget.onSave(course);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ShadDialog(
        title: Text(widget.course == null ? 'เพิ่มรายวิชา' : 'แก้ไขรายวิชา'),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ShadButton(onPressed: _saveCourse, child: const Text('บันทึก')),
        ],
        child: ShadForm(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(
                id: 'courseName',
                controller: _nameController,
                label: const Text('ชื่อวิชา'),
                placeholder: const Text('เช่น สังคมศึกษา, ระบบปฏิบัติการ'),
                validator: (value) =>
                    value.trim().isEmpty ? 'กรุณากรอกชื่อวิชา' : null,
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                id: 'description',
                controller: _descriptionController,
                label: const Text('คำอธิบาย'),
                placeholder: const Text(
                  'เช่น หมู่ 11, ห้อง 125, อาคาร 10 ชั้น 3',
                ),
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                id: 'teacherName',
                controller: _teacherController,
                label: const Text('ชื่อผู้สอน'),
                placeholder: const Text('เช่น ศ. ดร. งานเยอะ ได้นอนน้อย'),
              ),
              const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${dayName(schedule.day)} ${schedule.startTime!.format(context)} - ${schedule.endTime!.format(context)}${schedule.location != null ? ', ${schedule.location}' : ''}',
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
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _removeSchedule(index),
            child: Icon(
              PhosphorIconsRegular.trash,
              size: 24,
              color: theme.colorScheme.destructive,
            ),
          ),
        ],
      ),
    );
  }
}
