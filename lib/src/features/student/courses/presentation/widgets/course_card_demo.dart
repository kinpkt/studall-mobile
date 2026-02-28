import 'package:flutter/material.dart';
import 'package:studall/src/features/student/courses/presentation/widgets/course_card.dart';

class CourseCardDemo extends StatelessWidget {
  const CourseCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Card Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Course Cards',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Course Card with background image and avatar
            CourseCard(
              courseName: '68-2-01418342-MobileApp',
              section: 'หมู่ 1, 200',
              teacherName: 'Aurawan IMSOMBUT',
              backgroundImage: 'assets/images/course_bg1.jpg', // Add your asset
              avatarUrl: 'https://i.pravatar.cc/40?img=1',
              showAvatar: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mobile App Course tapped!')),
                );
              },
            ),

            const SizedBox(height: 16),

            // Course Card without background image
            CourseCard(
              courseName: '01418236-65 Operating Systems',
              section: 'หมู่ 2, 150',
              teacherName: 'Dr. John Smith',
              avatarUrl: 'https://i.pravatar.cc/40?img=2',
              showAvatar: true,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('OS Course tapped!')),
                );
              },
            ),

            const SizedBox(height: 16),

            // Course Card without avatar
            CourseCard(
              courseName: '01418321-65 Database Systems',
              section: 'หมู่ 1, 180',
              teacherName: 'Prof. Sarah Johnson',
              backgroundImage: 'assets/images/course_bg2.jpg',
              showAvatar: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Database Course tapped!')),
                );
              },
            ),

            const SizedBox(height: 24),

            // Usage instructions
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CourseCard Features:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('• Tap anywhere on the card for onTap callback'),
                    Text('• Optional background image support'),
                    Text('• Optional avatar display'),
                    Text('• Proper text overflow handling'),
                    Text('• StudALL design system integration'),
                    Text('• Exact Figma design implementation'),
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
