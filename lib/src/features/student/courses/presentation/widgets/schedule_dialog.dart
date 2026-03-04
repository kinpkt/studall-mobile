import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/features/student/courses/data/models/course_schedule_model.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

const Map<String, DayOfWeek> kDaysOfWeekMap = {
  'จันทร์': DayOfWeek.monday,
  'อังคาร': DayOfWeek.tuesday,
  'พุธ': DayOfWeek.wednesday,
  'พฤหัสบดี': DayOfWeek.thursday,
  'ศุกร์': DayOfWeek.friday,
  'เสาร์': DayOfWeek.saturday,
  'อาทิตย์': DayOfWeek.sunday,
};

String dayName(DayOfWeek day) =>
    kDaysOfWeekMap.entries.firstWhere((e) => e.value == day).key;

class ScheduleDialog extends StatefulWidget {
  final CourseScheduleModel? initialSchedule;
  final ValueChanged<CourseScheduleModel> onSave;

  const ScheduleDialog({super.key, this.initialSchedule, required this.onSave});

  /// แสดง dialog และเรียก [onSave] เมื่อบันทึก
  static Future<void> show(
    BuildContext context, {
    CourseScheduleModel? schedule,
    required ValueChanged<CourseScheduleModel> onSave,
  }) {
    return showDialog(
      context: context,
      builder: (_) => ScheduleDialog(initialSchedule: schedule, onSave: onSave),
    );
  }

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  final _formKey = GlobalKey<ShadFormState>();
  final _locationController = TextEditingController();

  late DayOfWeek _selectedDay;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  String? _location;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialSchedule?.day ?? DayOfWeek.monday;
    _startTime =
        widget.initialSchedule?.startTime ??
        const TimeOfDay(hour: 9, minute: 0);
    _endTime =
        widget.initialSchedule?.endTime ?? const TimeOfDay(hour: 10, minute: 0);
    _location = widget.initialSchedule?.location;
    _locationController.text = _location ?? '';
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  DateTime _toDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSave(
      CourseScheduleModel(
        day: _selectedDay,
        startTime: _startTime,
        endTime: _endTime,
        location: _location,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ShadDialog.alert(
        title: const Text('เลือกเวลาเรียน'),
        actions: [
          ShadButton.secondary(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ShadButton(onPressed: _submit, child: const Text('บันทึกเวลาเรียน')),
        ],
        child: Material(
          type: MaterialType.transparency,
          child: ShadForm(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(child: _buildDaySelector(theme)),
                      _buildTimePicker(
                        theme,
                        label: 'เริ่ม',
                        time: _startTime,
                        onChanged: (t) => setState(() => _startTime = t),
                      ),
                      _buildTimePicker(
                        theme,
                        label: 'สิ้นสุด',
                        time: _endTime,
                        onChanged: (t) => setState(() => _endTime = t),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ShadInputFormField(
                    id: 'location',
                    controller: _locationController,
                    label: const Text('สถานที่'),
                    placeholder: const Text('เช่น ห้อง 101, ห้อง 202, SC1-301'),
                    validator: (value) =>
                        value.trim().isEmpty ? 'กรุณากรอกสถานที่เรียน' : null,
                    onChanged: (val) => setState(() => _location = val),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector(ShadThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('วัน', style: theme.textTheme.small),
        const SizedBox(height: 8),
        ShadSelect<String>(
          placeholder: const Text('เลือกวัน'),
          initialValue: dayName(_selectedDay),
          options: kDaysOfWeekMap.keys
              .map(
                (day) => ShadOption(
                  value: day,
                  child: Text(
                    day,
                    style: theme.textTheme.custom['medium']?.copyWith(
                      color: theme.colorScheme.mutedForeground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              )
              .toList(),
          selectedOptionBuilder: (context, value) => Text(
            value,
            style: theme.textTheme.custom['medium']?.copyWith(
              color: theme.colorScheme.foreground,
              fontWeight: FontWeight.w400,
            ),
          ),
          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedDay = kDaysOfWeekMap[val]!);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimePicker(
    ShadThemeData theme, {
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: theme.textTheme.small),
        const SizedBox(height: 8),
        TimePickerSpinnerPopUp(
          mode: CupertinoDatePickerMode.time,
          initTime: _toDateTime(time),
          timeFormat: 'HH:mm',
          pressType: PressType.singlePress,
          locale: const Locale('th'),
          cancelText: 'ยกเลิก',
          confirmText: 'ยืนยัน',
          isCancelTextLeft: true,
          confirmTextStyle: theme.textTheme.small.copyWith(
            color: theme.colorScheme.foreground,
          ),
          cancelTextStyle: theme.textTheme.small.copyWith(
            color: theme.colorScheme.mutedForeground,
          ),
          onChange: (t) => onChanged(TimeOfDay.fromDateTime(t)),
          timeWidgetBuilder: (dateTime) => _buildTimeDisplay(theme, dateTime),
        ),
      ],
    );
  }

  Widget _buildTimeDisplay(ShadThemeData theme, DateTime dateTime) {
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
  }
}
