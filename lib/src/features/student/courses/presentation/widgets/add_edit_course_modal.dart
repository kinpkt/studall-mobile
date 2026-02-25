import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';

class AddEditCourseModal extends ConsumerStatefulWidget {
  CourseModel? course;
  AddEditCourseModal({super.key, this.course});

  @override
  ConsumerState<AddEditCourseModal> createState() => _AddEditCourseModalState();
}

class _AddEditCourseModalState extends ConsumerState<AddEditCourseModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // TODO: Collect data from _nameController and _schedules
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
                label: Text('คำอธิบายเพิ่มเติม', style: theme.textTheme.p,),
                placeholder: const Text('เช่น หมู่ 11, ห้อง 125, อาคาร 10 ชั้น 3'),
              ),
              const SizedBox(height: 16,),
              Text('เวลาเรียน', style: theme.textTheme.p),
              const SizedBox(height: 8,),
              ..._schedules.asMap().entries.map((entry) {
                final index = entry.key;
                final schedule = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
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
                      Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            const Text(' - '),
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
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        color: theme.colorScheme.destructive,
                        onPressed: () => _removeSchedule(index),
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
