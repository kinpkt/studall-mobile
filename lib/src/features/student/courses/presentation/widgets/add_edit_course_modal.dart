import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studall/src/features/student/courses/data/models/course_model.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:studall/src/features/student/courses/data/repositories/course_firestore_repository.dart';
import 'package:studall/src/features/student/home/presentation/widgets/schedule.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:flutter/cupertino.dart';

class AddEditCourseModal extends ConsumerStatefulWidget {
  CourseModel? course;
  AddEditCourseModal({super.key, this.course});

  @override
  ConsumerState<AddEditCourseModal> createState() => _AddEditCourseModalState();
}

class _AddEditCourseModalState extends ConsumerState<AddEditCourseModal> {
  final _formKey = GlobalKey<ShadFormState>();
  final _locationKey = GlobalKey<ShadFormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _teacherController = TextEditingController();
  final _locationController = TextEditingController();

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
    _locationController.dispose();
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
    final initialTime = isStart
        ? (_schedules[index].startTime ?? TimeOfDay.now())
        : (_schedules[index].endTime ?? TimeOfDay.now());

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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ShadDialog(
        title: Text('เพิ่มรายวิชา'),
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
                    const SnackBar(
                      content: Text('เกิดข้อผิดพลาด: ไม่พบข้อมูลผู้ใช้'),
                    ),
                  );
                  return;
                }

                final newCourse = CourseModel(
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

                if (widget.course == null) {
                  await ref
                      .read(courseFirestoreRepositoryProvider)
                      .addCourse(userId, newCourse);
                  ref.invalidate(courseFirestoreRepositoryProvider);
                } else {
                  await ref
                      .read(courseFirestoreRepositoryProvider)
                      .updateCourse(userId, newCourse);
                  ref.invalidate(courseFirestoreRepositoryProvider);
                }

                if (context.mounted) context.pop();
              }
            },
            child: const Text('บันทึก'),
          ),
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
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return 'กรุณากรอกชื่อวิชา';
                  }
                  return null;
                },
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
              ..._schedules.asMap().entries.map((entry) {
                final index = entry.key;
                final schedule = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${_daysOfWeekMap.keys.elementAt(index)} ${schedule.startTime!.format(context)} - ${schedule.endTime!.format(context)}, ${schedule.location ?? '-'}',
                          style: theme.textTheme.custom['medium']?.copyWith(
                            color: theme.colorScheme.foreground,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _showAddCourseTimeDialog(schedule, _schedules),
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
                    ],
                  ),
                );
              }),

              ShadButton.secondary(
                onPressed: () => _showAddCourseTimeDialog(null, _schedules),
                child: const Text('เพิ่มเวลาเรียน'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCourseTimeDialog(
    CourseScheduleModel? schedule,
    List<CourseScheduleModel>? schedules,
  ) {
    final theme = ShadTheme.of(context);

    DayOfWeek selectedDay = schedule?.day ?? DayOfWeek.monday;
    TimeOfDay startTime =
        schedule?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime =
        schedule?.endTime ?? const TimeOfDay(hour: 10, minute: 0);
    String? location = schedule?.location;

    // Helper สำหรับแปลงเวลา
    DateTime combineDateAndTime(TimeOfDay time) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShadDialog.alert(
                title: const Text('เลือกเวลาเรียน'),
                actions: [
                  ShadButton.secondary(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('ยกเลิก'),
                  ),
                  ShadButton(
                    onPressed: () {
                      if (!(_locationKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      if (schedule != null) {
                        setState(() {
                          schedule.day = selectedDay;
                          schedule.startTime = startTime;
                          schedule.endTime = endTime;
                          schedule.location = location;
                        });
                      } else {
                        setState(() {
                          _schedules.add(
                            CourseScheduleModel(
                              day: selectedDay,
                              startTime: startTime,
                              endTime: endTime,
                              location: location,
                            ),
                          );
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('บันทึกเวลาเรียน'),
                  ),
                ],
                child: Material(
                  type: MaterialType.transparency,
                  child: ShadForm(
                    key: _locationKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            spacing: 8,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('วัน', style: theme.textTheme.small),
                                    const SizedBox(height: 8),
                                    ShadSelect<String>(
                                      placeholder: const Text('เลือกวัน'),
                                      initialValue: _daysOfWeekMap.entries
                                          .firstWhere(
                                            (entry) =>
                                                entry.value == selectedDay,
                                          )
                                          .key,
                                      options: _daysOfWeekMap.keys
                                          .map(
                                            (day) => ShadOption(
                                              value: day,
                                              child: Text(
                                                day,
                                                style: theme
                                                    .textTheme
                                                    .custom['medium']
                                                    ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .mutedForeground,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      selectedOptionBuilder: (context, value) =>
                                          Text(
                                            value,
                                            style: theme
                                                .textTheme
                                                .custom['medium']
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .foreground,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                      onChanged: (val) {
                                        if (val != null) {
                                          setDialogState(
                                            () => selectedDay =
                                                _daysOfWeekMap[val]!,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('เริ่ม', style: theme.textTheme.small),
                                  const SizedBox(height: 8),
                                  TimePickerSpinnerPopUp(
                                    mode: CupertinoDatePickerMode.time,
                                    initTime: combineDateAndTime(startTime),
                                    timeFormat: 'HH:mm',
                                    pressType: PressType.singlePress,
                                    locale: const Locale('th'),
                                    cancelText: 'ยกเลิก',
                                    confirmText: 'ยืนยัน',
                                    isCancelTextLeft: true,

                                    confirmTextStyle: theme.textTheme.small
                                        .copyWith(
                                          color: theme.colorScheme.foreground,
                                        ),
                                    cancelTextStyle: theme.textTheme.small
                                        .copyWith(
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                    onChange: (time) {
                                      setDialogState(
                                        () => startTime =
                                            TimeOfDay.fromDateTime(time),
                                      );
                                    },
                                    timeWidgetBuilder: (dateTime) =>
                                        _buildTimeDisplay(context, dateTime),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,

                                children: [
                                  Text('สิ้นสุด', style: theme.textTheme.small),
                                  const SizedBox(height: 8),
                                  TimePickerSpinnerPopUp(
                                    mode: CupertinoDatePickerMode.time,
                                    initTime: combineDateAndTime(endTime),
                                    timeFormat: 'HH:mm',
                                    pressType: PressType.singlePress,
                                    locale: const Locale('th'),
                                    cancelText: 'ยกเลิก',
                                    confirmText: 'ยืนยัน',
                                    isCancelTextLeft: true,

                                    confirmTextStyle: theme.textTheme.small
                                        .copyWith(
                                          color: theme.colorScheme.foreground,
                                        ),
                                    cancelTextStyle: theme.textTheme.small
                                        .copyWith(
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                    onChange: (time) {
                                      setDialogState(
                                        () => endTime = TimeOfDay.fromDateTime(
                                          time,
                                        ),
                                      );
                                    },
                                    timeWidgetBuilder: (dateTime) =>
                                        _buildTimeDisplay(context, dateTime),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ShadInputFormField(
                            id: 'location',
                            controller: _locationController
                              ..text = location ?? '',
                            label: const Text('สถานที่'),
                            placeholder: const Text(
                              'เช่น ห้อง 101, ห้อง 202, SC1-301',
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty) {
                                return 'กรุณากรอกสถานที่เรียน';
                              }
                              return null;
                            },
                            onChanged: (val) {
                              setDialogState(() => location = val);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeDisplay(BuildContext context, DateTime dateTime) {
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}",
        style: theme.textTheme.custom['medium']?.copyWith(
          color: theme.colorScheme.foreground,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

           //   Container(
              //     margin: const EdgeInsets.only(bottom: 12.0),
              //     padding: const EdgeInsets.all(8.0),
              //     decoration: BoxDecoration(
              //       border: Border.all(color: theme.colorScheme.border),
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Row(
              //           children: [
              //             Expanded(
              //               child: ShadSelect<String>(
              //                 initialValue: _daysOfWeekMap.entries
              //                     .firstWhere(
              //                       (entry) => entry.value == schedule.day,
              //                     )
              //                     .key,
              //                 selectedOptionBuilder: (context, value) =>
              //                     Text(value),
              //                 options: _daysOfWeekMap.keys
              //                     .map(
              //                       (dayName) => ShadOption(
              //                         value: dayName,
              //                         child: Text(dayName),
              //                       ),
              //                     )
              //                     .toList(),
              //                 onChanged: (val) {
              //                   if (val != null) {
              //                     setState(
              //                       () => _schedules[index].day =
              //                           _daysOfWeekMap[val]!,
              //                     );
              //                   }
              //                 },
              //               ),
              //             ),
              //             const SizedBox(width: 8),
              //             GestureDetector(
              //               onTap: () => _pickTime(index, true),
              //               child: Container(
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 12,
              //                   vertical: 8,
              //                 ),
              //                 decoration: BoxDecoration(
              //                   border: Border.all(
              //                     color: theme.colorScheme.border,
              //                   ),
              //                   borderRadius: BorderRadius.circular(6),
              //                 ),
              //                 child: Text(
              //                   schedule.startTime?.format(context) ?? 'เริ่ม',
              //                   style: theme.textTheme.muted,
              //                 ),
              //               ),
              //             ),
              //             const Padding(
              //               padding: EdgeInsets.symmetric(horizontal: 8.0),
              //               child: Text('-'),
              //             ),
              //             GestureDetector(
              //               onTap: () => _pickTime(index, false),
              //               child: Container(
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 12,
              //                   vertical: 8,
              //                 ),
              //                 decoration: BoxDecoration(
              //                   border: Border.all(
              //                     color: theme.colorScheme.border,
              //                   ),
              //                   borderRadius: BorderRadius.circular(6),
              //                 ),
              //                 child: Text(
              //                   schedule.endTime?.format(context) ?? 'สิ้นสุด',
              //                   style: theme.textTheme.muted,
              //                 ),
              //               ),
              //             ),
              //             IconButton(
              //               icon: const Icon(Icons.close, size: 20),
              //               color: theme.colorScheme.destructive,
              //               onPressed: () => _removeSchedule(index),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 12),
              //         ShadInput(
              //           placeholder: const Text(
              //             'สถานที่ (เช่น อาคาร 10 ห้อง 101)',
              //           ),
              //           keyboardType: TextInputType.text,
              //           initialValue: schedule.location,
              //           onChanged: (val) {
              //             setState(() {
              //               schedule.location = val;
              //             });
              //           },
              //         ),
              //       ],
              //     ),
              //   );
              // }),