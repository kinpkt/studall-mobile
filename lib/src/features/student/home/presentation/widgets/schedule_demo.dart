import 'package:flutter/material.dart';
import 'package:studall/src/features/student/home/data/models/schedule_model.dart';
import 'package:studall/src/features/student/home/presentation/widgets/schedule.dart';

class ScheduleDemo extends StatelessWidget {
  const ScheduleDemo({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample schedule data
    List<ScheduleModel> sampleSchedule = [
      ScheduleModel(
        id: '1',
        courseId: '01418342-65',
        title: 'Mobile Application Design and Development',
        location: 'SC1-202',
        section: 'Sec 1',
        dayOfWeek: 1, // Monday
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 12, minute: 0),
      ),
      ScheduleModel(
        id: '2', 
        courseId: '01418236-65',
        title: 'Operating Systems',
        location: 'SC1-104',
        section: 'Sec 2',
        dayOfWeek: 2, // Tuesday
        startTime: const TimeOfDay(hour: 13, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
      ),
      ScheduleModel(
        id: '3',
        courseId: '01418321-65', 
        title: 'Database Systems',
        location: 'Online',
        section: 'Sec 1',
        dayOfWeek: 3, // Wednesday
        startTime: const TimeOfDay(hour: 10, minute: 30),
        endTime: const TimeOfDay(hour: 12, minute: 30),
      ),
      ScheduleModel(
        id: '4',
        courseId: '01418497-65',
        title: 'Senior Project',
        location: 'SC1-301',
        dayOfWeek: 5, // Friday
        startTime: const TimeOfDay(hour: 14, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'วันนี้',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Horizontal Schedule Widget
            Schedule(
              scheduleItems: sampleSchedule,
              height: 200,
            ),
            
            const SizedBox(height: 16),
            
            // Usage instructions
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usage Instructions:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Scroll horizontally to view different times'),
                    Text('• Each minute = 2 pixels (24hr = 2880px wide)'),
                    Text('• Tap on schedule blocks for interactions'),
                    Text('• Colors are assigned based on day of week'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}