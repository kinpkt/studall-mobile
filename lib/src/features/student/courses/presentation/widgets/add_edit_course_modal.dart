import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';

class AddEditCourseModal extends ConsumerStatefulWidget {
  CourseModel? course;
  AddEditCourseModal({super.key, this.course});

  @override
  ConsumerState<AddEditCourseModal> createState() => _AddEditCourseModalState();
}

class _AddEditCourseModalState extends ConsumerState<AddEditCourseModal> {
  final _formKey = GlobalKey<ShadFormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teacherController = TextEditingController();

  final List<CourseScheduleModel> _schedules = [];
  final Map<String, DayOfWeek> _daysOfWeekMap = {
    'จันทร์': DayOfWeek.monday,
    'อังคาร': DayOfWeek.tuesday,
    'พุธ': DayOfWeek.wednesday,
    'พฤหัสบดี': DayOfWeek.thursday,
    'ศุกร์': DayOfWeek.friday,
    'เสาร์': DayOfWeek.saturday,
    'อาทิตย์': DayOfWeek.sunday,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _addSchedule() {
    setState(() {
      _schedules.add(CourseScheduleModel(day: _daysOfWeekMap.values.first));
    });
  }

  void _removeSchedule(int index) {
    setState(() {
      _schedules.removeAt(index);
    });
  }

  Future<void> _pickTime(int index, bool isStart) async {
    final initialTime = isStart ? (_schedules[index].startTime ?? TimeOfDay.now()) : (_schedules[index].endTime ?? TimeOfDay.now());

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _schedules[index].startTime = pickedTime;
        } else {
          _schedules[index].endTime = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadDialog(
      title: Text('เพิ่มรายวิชา', style: theme.textTheme.h4),
      actions: [
        ShadButton.outline(
          onPressed: () => Navigator.pop(context),
          child: const Text('ยกเลิก'),
        ),
        ShadButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final userId = FirebaseAuth.instance.currentUser?.uid;

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เกิดข้อผิดพลาด: ไม่พบข้อมูลผู้ใช้')),
                );
                return;
              }

              final newCourse = CourseModel(
                name: _nameController.text.trim(),
                description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
                teacherName: _teacherController.text.trim().isEmpty ? null : _teacherController.text.trim(),
                userId: userId,
                isActive: true,
                schedule: _schedules,
              );

              if (widget.course == null) {
                await ref.read(courseFirestoreRepositoryProvider).addCourse(
                    newCourse);
                ref.invalidate(courseFirestoreRepositoryProvider);
              }
              else {
                await ref.read(courseFirestoreRepositoryProvider).updateCourse(
                    newCourse);
                ref.invalidate(courseFirestoreRepositoryProvider);
              }

              if (mounted)
                Navigator.pop(context);
            }
          },
          child: const Text('บันทึก'),
        ),
      ],
      child: ShadForm(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShadInputFormField(
              id: 'courseName',
              controller: _nameController,
              label: Text('ชื่อวิชา', style: theme.textTheme.p,),
              placeholder: const Text('เช่น สังคมศึกษา, ระบบปฏิบัติการ'),
              validator: (value) {
                if (value.trim().isEmpty) {
                  return 'กรุณากรอกชื่อวิชา';
                }
                return null;
              },
            ),
            const SizedBox(height: 16,),
            ShadInputFormField(
              id: 'description',
              controller: _descriptionController,
              label: Text('คำอธิบายเพิ่มเติม', style: theme.textTheme.p,),
              placeholder: const Text('เช่น หมู่ 11, ห้อง 125, อาคาร 10 ชั้น 3'),
            ),
            const SizedBox(height: 16,),
            ShadInputFormField(
              id: 'teacherName',
              controller: _teacherController,
              label: Text('ชื่อผู้สอน', style: theme.textTheme.p,),
              // TODO: Rename placeholder
              placeholder: const Text('เช่น ศ. ดร. งานเยอะ ได้นอนน้อย'),
            ),
            const SizedBox(height: 16,),
            Text('เวลาเรียน', style: theme.textTheme.p),
            const SizedBox(height: 8,),
            ..._schedules.asMap().entries.map((entry) {
              final index = entry.key;
              final schedule = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ShadSelect<String>(
                            initialValue: _daysOfWeekMap.entries.firstWhere(
                                    (entry) => entry.value == schedule.day
                            ).key,
                            selectedOptionBuilder: (context, value) => Text(value),
                            options: _daysOfWeekMap.keys.map(
                                    (dayName) => ShadOption(value: dayName, child: Text(dayName))
                            ).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _schedules[index].day = _daysOfWeekMap[val]!);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8,),
                        GestureDetector(
                          onTap: () => _pickTime(index, true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.colorScheme.border),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              schedule.startTime?.format(context) ?? 'เริ่ม',
                              style: theme.textTheme.muted,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('-'),
                        ),
                        GestureDetector(
                          onTap: () => _pickTime(index, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.colorScheme.border),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              schedule.endTime?.format(context) ?? 'สิ้นสุด',
                              style: theme.textTheme.muted,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          color: theme.colorScheme.destructive,
                          onPressed: () => _removeSchedule(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ShadInput(
                      placeholder: const Text('สถานที่ (เช่น อาคาร 10 ห้อง 101)'),
                      keyboardType: TextInputType.text,
                      initialValue: schedule.location,
                      onChanged: (val) {
                        setState(() {
                          schedule.location = val;
                        });
                      },
                    ),
                  ],
                ),
              );
            }),
            ShadButton.ghost(
              onPressed: _addSchedule,
              child: const Text('+ เพิ่มเวลาเรียน'),
            ),
          ],
        )
      ),
    );
  }
}
