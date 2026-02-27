import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:studall/src/common_widgets/common_app_bar.dart';
import 'package:studall/src/common_widgets/checkbox_card.dart';
import 'package:studall/src/features/student/presentation/screens/student_layout_screen.dart';

class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  State<CourseSelectionScreen> createState() => _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  bool _course1Selected = true;
  bool _course2Selected = false;
  bool _course3Selected = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: _buildAppBar(context),
      bottomNavigationBar: Container(
        color: colorScheme.background,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadButton.secondary(
                  child: const Text('เพิ่มวิชาเรียนด้วยตัวเอง'),
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                ShadButton(
                  child: const Text('ยืนยันวิชาเรียน'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 392),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16.0),

              Column(
                children: [
                  Text(
                    'เลือกวิชาที่จะแสดง',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.h3.copyWith(
                      color: colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'เลือกเฉพาะวิชาที่คุณกำลังเรียนในเทอมนี้ \nเพื่อซ่อนวิชาเก่าหรือวิชาที่ไม่จำเป็น',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.muted.copyWith(
                      color: colorScheme.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
              Column(
                spacing: 16.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('วิชา', style: theme.textTheme.custom['medium']),
                      const SizedBox(width: 16.0),

                      GestureDetector(
                        child: Icon(
                          size: 20.0,
                          PhosphorIconsRegular.plus,
                          color: colorScheme.mutedForeground,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  CheckboxCard(
                    courseCode: 'การกินราเมง',
                    section: 'หมู่ กรอบ',
                    teacherName: 'Athiruj Kaewseesuk',
                    value: _course1Selected,
                    onChanged: (value) =>
                        setState(() => _course1Selected = value ?? false),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
              Column(
                spacing: 16.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Classroom',
                        style: theme.textTheme.custom['medium'],
                      ),
                    ],
                  ),
                  CheckboxCard(
                    courseCode: '68-2-01418342-MobileApp',
                    section: 'หมู่ 1, 200',
                    teacherName: 'Aurawan IMSOMBUT',
                    value: _course2Selected,
                    onChanged: (value) =>
                        setState(() => _course2Selected = value ?? false),
                    backgroundImage: 'assets/images/student.png',
                    avatarUrl:
                        'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
                  ),
                  CheckboxCard(
                    courseCode: '01355231-Software Engineering',
                    section: 'หมู่ 2, 150',
                    teacherName: 'Somchai DEVELOPER',
                    value: _course3Selected,
                    onChanged: (value) =>
                        setState(() => _course3Selected = value ?? false),
                    backgroundImage: 'assets/images/student.png',
                    avatarUrl:
                        'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  CommonAppbar _buildAppBar(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;

    return CommonAppbar(
      actions: [
        GestureDetector(
          child: Row(
            children: [
              Text('ข้ามไปก่อน', style: theme.textTheme.p),
              const SizedBox(width: 8),
              Icon(
                size: 24.0,
                PhosphorIconsRegular.caretDoubleRight,
                color: colorScheme.foreground,
              ),
            ],
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const StudentLayoutScreen(),
            ),
          ),
        ),
      ],
    );
  }
}
