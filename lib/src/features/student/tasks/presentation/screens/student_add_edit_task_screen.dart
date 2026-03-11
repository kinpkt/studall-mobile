import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/core/utils/time_conversion.dart';
import 'package:studall/src/features/student/courses/presentation/providers/course_list_provider.dart';

import '../../data/models/task_model.dart';
import '../providers/student_add_edit_task_provider.dart';

class StudentAddEditTaskScreen extends ConsumerStatefulWidget {
  final TaskModel? task;
  const StudentAddEditTaskScreen({super.key, this.task});

  @override
  ConsumerState<StudentAddEditTaskScreen> createState() => _StudentAddEditTaskScreenState();
}

class _StudentAddEditTaskScreenState extends ConsumerState<StudentAddEditTaskScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    final coursesAsync = ref.watch(userCoursesProvider);

    final currentTaskType = ref.watch(taskTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'เพิ่มภาระงานใหม่' : 'แก้ไขข้อมูลภาระงาน', style: theme.textTheme.h3,),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ShadForm(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              coursesAsync.when(
                data: (courses) {
                  return ShadSelectFormField<String>(
                    id: 'courseId',
                    label: const Text('รายวิชา'),
                    placeholder: const Text('เลือกรายวิชา'),
                    allowDeselection: true,
                    selectedOptionBuilder: (context, value) {
                      final selectedCourse = courses.firstWhere(
                        (c) => c.id == value,
                        orElse: () => courses.first,
                      );
                      return Text(selectedCourse.name);
                    },
                    options: courses.map((course) {
                      return ShadOption(
                        value: course.id,
                        child: Text(course.name),
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
                  return Text('Error loading courses: $error', style: const TextStyle(color: Colors.red));
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
                id: 'type',
                label: const Text('ประเภทภาระงาน'),
                initialValue: TaskType.toDo,
                placeholder: const Text('Select task type'),
                selectedOptionBuilder: (context, value) {
                  return Text(value.thaiName);
                },
                options: TaskType.values.map(
                  (e) => ShadOption(
                    value: e,
                    child: Text(e.thaiName),
                  )
                ).toList(),
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
                      flex: 2,
                      child: ShadDatePickerFormField(
                        id: 'startDate',
                        label: const Text('วันที่เริ่มนัดหมาย'),
                        placeholder: const Text('เลือกวันที่'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null && context.mounted) {
                            final localizations = MaterialLocalizations.of(context);
                            _startTimeController.text = localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
                          }
                        },
                        child: AbsorbPointer(
                          child: ShadInputFormField(
                            id: 'startTime',
                            controller: _startTimeController,
                            label: const Text('เวลา'),
                            placeholder: const Text('HH:MM'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ShadDatePickerFormField(
                      id: 'endDate',
                      label: Text(currentTaskType == TaskType.toDo ? 'วันที่ครบกำหนด' : 'วันที่สิ้นสุดนัดหมาย'),
                      placeholder: const Text('เลือกวันที่'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null && context.mounted) {
                          final localizations = MaterialLocalizations.of(context);
                          _endTimeController.text = localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
                        }
                      },
                      child: AbsorbPointer(
                        child: ShadInputFormField(
                          id: 'endTime',
                          controller: _endTimeController,
                          label: const Text('เวลา'),
                          placeholder: const Text('HH:MM'),
                        ),
                      ),
                    ),
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
                onPressed: () {
                  try {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final formData = _formKey.currentState!.value;

                      DateTime? startDateTime;
                      DateTime? endDateTime;

                      if (formData['type'] == TaskType.appointment) {
                        startDateTime = combineDateTime(
                          formData['startDate'] as DateTime?,
                          formData['startTime'] as String?,
                        );
                      }

                      endDateTime = combineDateTime(
                        formData['endDate'] as DateTime?,
                        formData['endTime'] as String?,
                      );

                      final newTask = TaskModel(
                        courseId: formData['courseId'] as String,
                        title: formData['title'] as String,
                        description: formData['description'] as String?,
                        type: formData['type'],
                        isShownInSchedule: formData['isShownInSchedule'] as bool? ?? false,
                        startDateTime: startDateTime,
                        endDateTime: endDateTime!,
                      );

                      final isNewTask = widget.task == null;
                      ref.read(studentAddEditTaskProvider.notifier).submitTask(newTask, isNewTask);
                      debugPrint('Form submitted with: $formData');

                      if (!context.mounted)
                        return;

                      ShadToaster.of(context).show(
                        const ShadToast(description: Text('บันทึกภาระงานสำเร็จ')),
                      );

                      context.pop();
                    }
                  }
                  catch (e) {
                    if (!context.mounted)
                      return;

                    ShadToaster.of(context).show(
                      const ShadToast(description: Text('พบข้อผิดพลาดในระหว่างการบันทึกภาระงาน กรุณาลองใหม่อีกครั้ง')),
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