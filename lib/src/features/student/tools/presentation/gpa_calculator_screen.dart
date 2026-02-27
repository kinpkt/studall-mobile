import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class GPACalculatorScreen extends StatefulWidget {
  const GPACalculatorScreen({super.key});

  @override
  State<GPACalculatorScreen> createState() => _GPACalculatorScreenState();
}

class _GPACalculatorScreenState extends State<GPACalculatorScreen> {
  final List<Map<String, dynamic>> _courses = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  double? _parseGrade(String input) {
    final text = input.trim().toUpperCase();

    const letterToGrade = {
      'A': 4.0,
      'B+': 3.5,
      'B': 3.0,
      'C+': 2.5,
      'C': 2.0,
      'D+': 1.5,
      'D': 1.0,
      'F': 0.0,
    };

    if (letterToGrade.containsKey(text)) {
      return letterToGrade[text];
    }

    final numGrade = double.tryParse(text);
    if (numGrade != null && numGrade >= 0.0 && numGrade <= 4.0) {
      return numGrade;
    }

    return null;
  }

  void _addCourse() {
    final gradeStr = _gradeController.text;
    final parsedGrade = _parseGrade(gradeStr);

    // Only add if all fields have data AND the grade is valid
    if (_nameController.text.isNotEmpty &&
        _creditController.text.isNotEmpty &&
        parsedGrade != null) {
      setState(() {
        _courses.add({
          'name': _nameController.text,
          'credits': double.tryParse(_creditController.text) ?? 3.0,
          'grade': parsedGrade,
          // Store what the user actually typed so we can display it nicely in the list
          'displayGrade': gradeStr.trim().toUpperCase(),
        });
        _nameController.clear();
        _creditController.clear();
        _gradeController.clear();
      });
    }
  }

  double _calculateGPA() {
    double totalCredits = 0;
    double totalPoints = 0;

    for (var course in _courses) {
      totalCredits += course['credits'];
      totalPoints += course['credits'] * course['grade'];
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('คำนวณเกรดเฉลี่ย', style: theme.textTheme.h1,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ShadInput(
                    controller: _nameController,
                    placeholder: const Text('ชื่อวิชา'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ShadInput(
                    controller: _creditController,
                    placeholder: const Text('หน่วยกิต'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ShadInput(
                    controller: _gradeController,
                    placeholder: const Text('เกรด'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ShadButton(
                onPressed: _addCourse,
                child: Text('เพิ่มวิชา', style: theme.textTheme.p,),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'วิชาทั้งหมด',
              style: theme.textTheme.h3,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _courses.isEmpty
                  ? Center(child: Text('ยังไม่มีวิชาให้คำนวณ', style: theme.textTheme.h4,))
                  : ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ShadCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course['name'],
                                style: theme.textTheme.p,
                              ),
                              const SizedBox(height: 4),
                              Text('${course['credits']} หน่วยกิต', style: theme.textTheme.p,),
                            ],
                          ),
                          Text(
                            course['displayGrade'],
                            style: theme.textTheme.large,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ShadTheme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'เกรดเฉลี่ย',
                    style: theme.textTheme.h2,
                  ),
                  Text(
                    _calculateGPA().toStringAsFixed(2),
                    style: theme.textTheme.h2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}