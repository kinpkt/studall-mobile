import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/core/utils/time_conversion.dart';
import 'package:studall/src/features/student/courses/presentation/providers/course_list_provider.dart';

import '../../data/models/task_model.dart';
import '../providers/student_add_edit_task_provider.dart';

class StudentAddEditTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;
  final String? initialCourseId;
  const StudentAddEditTaskScreen({super.key, this.task, this.initialCourseId});

  @override
  ConsumerState<StudentAddEditTaskScreen> createState() =>
      _StudentAddEditTaskScreenState();
}

class _StudentAddEditTaskScreenState
    extends ConsumerState<StudentAddEditTaskScreen> {
  final _formKey = GlobalKey<ShadFormState>();
  late final ShadSelectController<String> _courseController;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _courseController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final courseId = widget.task?.courseId ?? widget.initialCourseId;
    _courseController = ShadSelectController<String>(
      initialValue: {if (courseId != null) courseId},
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskTypeProvider.notifier).state =
          widget.task?.type ?? TaskType.toDo;
    });
  }

  DateTime _toDateTime(TimeOfDay? time) {
    final now = DateTime.now();
    final t = time ?? TimeOfDay.now();
    return DateTime(now.year, now.month, now.day, t.hour, t.minute);
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTimePicker(
    ShadThemeData theme, {
    required String label,
    required TimeOfDay? time,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.small.copyWith(height: 20 / 14)),
        const SizedBox(height: 8),
        TimePickerSpinnerPopUp(
          mode: CupertinoDatePickerMode.time,
          initTime: null,
          timeFormat: 'HH:mm',
          pressType: PressType.singlePress,
          locale: const Locale('th'),
          cancelText: 'ยกเลิก',
          confirmText: 'ยืนยัน',
          isCancelTextLeft: true,
          confirmTextStyle: theme.textTheme.muted.copyWith(
            color: theme.colorScheme.foreground,
          ),
          cancelTextStyle: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
          ),
          onChange: (t) => onChanged(TimeOfDay.fromDateTime(t)),
          timeWidgetBuilder: (dateTime) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.border),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                style: theme.textTheme.custom['medium']?.copyWith(
                  color: theme.colorScheme.foreground,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final coursesAsync = ref.watch(userCoursesProvider);

    final currentTaskType = ref.watch(taskTypeProvider);

    return Scaffold(
      appBar: CommonAppbar(
        title: widget.task == null ? 'เพิ่มภาระงานใหม่' : 'แก้ไขข้อมูลภาระงาน',
        subtitle: widget.initialCourseId != null
            ? coursesAsync.whenOrNull(
                data: (courses) => courses
                    .where((c) => c.id == widget.initialCourseId)
                    .firstOrNull
                    ?.name,
              )
            : null,
        leading: [
          ShadIconButton.ghost(
            decoration: ShadDecoration(shape: BoxShape.circle),
            icon: const Icon(PhosphorIconsRegular.arrowLeft),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ShadForm(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.initialCourseId == null)
                coursesAsync.when(
                  data: (courses) {
                    return ShadSelectFormField<String>(
                      id: 'courseId',
                      label: const Text('รายวิชา'),
                      placeholder: const Text('เลือกรายวิชา'),
                      controller: _courseController,
                      allowDeselection: true,
                      minWidth: double.infinity,
                      selectedOptionBuilder: (context, value) {
                        final selectedCourse = courses.firstWhere(
                          (c) => c.id == value,
                          orElse: () => courses.first,
                        );
                        return Text(
                          selectedCourse.name,
                          style: theme.textTheme.custom['medium']?.copyWith(
                            color: theme.colorScheme.foreground,
                            fontWeight: FontWeight.w400,
                          ),
                        );
                      },

                      options: courses.map((course) {
                        return ShadOption(
                          value: course.id,
                          child: Text(
                            course.name,
                            style: theme.textTheme.custom['medium']?.copyWith(
                              color: theme.colorScheme.foreground,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  error: (error, stack) {
                    return Text(
                      'Error loading courses: $error',
                      style: const TextStyle(color: Colors.red),
                    );
                  },
                ),
              const SizedBox(height: 16),
              ShadInputFormField(
                id: 'title',
                label: const Text('ชื่อภาระงาน'),
                placeholder: const Text('กรอกชื่อภาระงาน'),
                validator: (v) {
                  if (v.isEmpty) return 'กรุณากรอกชื่อภาระงาน';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                id: 'description',
                label: const Text('คำอธิบายประกอบ'),
                placeholder: const Text('กรอกคำอธิบายประกอบ (ไม่บังคับ)'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ShadSelectFormField<TaskType>(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                id: 'type',
                label: const Text('ประเภทภาระงาน'),
                minWidth: double.infinity,
                initialValue: currentTaskType,
                placeholder: const Text('Select task type'),
                selectedOptionBuilder: (context, value) {
                  return Text(
                    value.thaiName,
                    style: theme.textTheme.custom['medium']?.copyWith(
                      color: theme.colorScheme.foreground,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                },
                options: TaskType.values
                    .map((e) => ShadOption(value: e, child: Text(e.thaiName)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    ref.read(taskTypeProvider.notifier).state = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              if (currentTaskType == TaskType.appointment) ...[
                Row(
                  children: [
                    Expanded(
                      child: ShadDatePickerFormField(
                        id: 'startDate',
                        label: Text('วันที่เริ่มนัดหมาย'),
                        placeholder: Text(
                          'เลือกวันที่',
                          style: textTheme.custom['medium']?.copyWith(
                            color: colorScheme.mutedForeground,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        height: 44,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildTimePicker(
                      theme,
                      label: 'เวลา',
                      time: _startTime,
                      onChanged: (t) => setState(() => _startTime = t),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: ShadDatePickerFormField(
                      id: 'endDate',
                      label: Text(
                        currentTaskType == TaskType.toDo
                            ? 'วันที่ครบกำหนด'
                            : 'วันที่สิ้นสุดนัดหมาย',
                      ),
                      placeholder: Text(
                        'เลือกวันที่',
                        style: textTheme.custom['medium']?.copyWith(
                          color: colorScheme.mutedForeground,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildTimePicker(
                    theme,
                    label: 'เวลา',
                    time: _endTime,
                    onChanged: (t) => setState(() => _endTime = t),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (currentTaskType == TaskType.appointment) ...[
                ShadCheckboxFormField(
                  id: 'isShownInSchedule',
                  initialValue: false,
                  inputLabel: const Text('ต้องการให้แสดงผลบนตารางเรียนหรือไม่'),
                ),
              ],
              const SizedBox(height: 16),
              ShadButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final formData = _formKey.currentState!.value;

                      DateTime? startDateTime;
                      DateTime? endDateTime;

                      if (formData['type'] == TaskType.appointment) {
                        startDateTime = combineDateTime(
                          formData['startDate'] as DateTime?,
                          _formatTime(_startTime),
                        );
                      }

                      endDateTime = combineDateTime(
                        formData['endDate'] as DateTime?,
                        _formatTime(_endTime),
                      );

                      final newTask = TaskModel(
                        courseId:
                            widget.initialCourseId ??
                            formData['courseId'] as String?,
                        title: formData['title'] as String,
                        description: formData['description'] as String?,
                        type: formData['type'],
                        isShownInSchedule:
                            formData['isShownInSchedule'] as bool? ?? false,
                        startDateTime: startDateTime,
                        endDateTime: endDateTime!,
                      );

                      final isNewTask = widget.task == null;
                      await ref
                          .read(studentAddEditTaskProvider.notifier)
                          .submitTask(newTask, isNewTask);
                      debugPrint('Form submitted with: $formData');

                      if (!context.mounted) return;

                      ShadToaster.of(context).show(
                        const ShadToast(
                          description: Text('บันทึกภาระงานสำเร็จ'),
                        ),
                      );

                      context.pop();
                    }
                  } catch (e) {
                    if (!context.mounted) return;

                    ShadToaster.of(context).show(
                      const ShadToast.destructive(
                        description: Text(
                          'พบข้อผิดพลาดในระหว่างการบันทึกภาระงาน กรุณาลองใหม่อีกครั้ง',
                        ),
                      ),
                    );

                    debugPrint('Error found: $e');
                  }
                },
                child: const Text('บันทึกงาน'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
