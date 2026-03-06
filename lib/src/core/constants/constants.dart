import '/src/features/student/data/models/utility_model.dart';

final kPreferredSize = 92;

final kDemoRecentItems = [
  UtilityModel(
    courseId: 'CS101',
    type: UtilityType.assignment,
    title: 'ทำแบบฝึกหัดบทที่ 1-3',
    description: 'ทำแบบฝึกหัดในชีทให้ครบทุกข้อ',
    dueDate: DateTime.now().add(const Duration(days: 2, hours: 5)),
  ),
  UtilityModel(
    courseId: 'CS102',
    type: UtilityType.material,
    title: 'ชีทสรุปบทที่ 4-6',
    description: 'สรุปเนื้อหาและตัวอย่างโจทย์ในบทที่ 4-6',
  ),
  UtilityModel(
    courseId: 'CS103',
    type: UtilityType.assignment,
    title: 'เตรียมพรีเซนต์โปรเจกต์',
    description: 'เตรียมสไลด์และเนื้อหาสำหรับพรีเซนต์โปรเจกต์ในสัปดาห์หน้า',
    dueDate: DateTime.now().add(const Duration(days: 5)),
  ),
];

final kDemoTaskTiles = [
  UtilityModel(
    courseId: 'CS101',
    type: UtilityType.assignment,
    title: 'ทำแบบฝึกหัดบทที่ 1-3',
    description: 'ทำแบบฝึกหัดในชีทให้ครบทุกข้อ',
    dueDate: DateTime.now().add(const Duration(days: 2, hours: 5)),
  ),
  UtilityModel(
    courseId: 'CS102',
    type: UtilityType.assignment, 
    title: 'ส่งรายงานโปรเจกต์กลุ่ม',
    description: 'จัดทำรายงานและ source code พร้อมส่งผ่าน LMS',
    dueDate: DateTime.now().add(const Duration(days: 7)),
  ),
  UtilityModel(
    courseId: 'CS103',
    type: UtilityType.assignment,
    title: 'Quiz บทที่ 5 - Algorithm',
    description: 'ทบทวนเนื้อหา Sorting และ Searching algorithms',
    dueDate: DateTime.now().add(const Duration(hours: 20)),
  ),
  UtilityModel(
    courseId: 'CS101',
    type: UtilityType.event,
    title: 'สอบกลางภาค CS101',
    description: 'สอบที่ห้อง SC1-501 เวลา 09:00 - 12:00 น.',
    dueDate: DateTime.now().add(const Duration(days: 14)),
  ),
  UtilityModel(
    courseId: 'CS104',
    type: UtilityType.event,
    title: 'งานวิชาการ KU Open House',
    description: 'กิจกรรม Open House คณะวิทยาศาสตร์ มหาวิทยาลัยเกษตรศาสตร์',
    dueDate: DateTime.now().add(const Duration(days: 10)),
  ),
  UtilityModel(
    courseId: 'CS102',
    type: UtilityType.event,
    title: 'นำเสนอโปรเจกต์ขั้นกลาง',
    description: 'เตรียม demo และ slide สำหรับนำเสนอต่ออาจารย์และกลุ่มเพื่อน',
    dueDate: DateTime.now().add(const Duration(days: 5)),
  ),
];

final kDemoMaterialTiles = [
  UtilityModel(
    courseId: 'CS101',
    type: UtilityType.note,
    title: 'สรุปบทที่ 1 - Introduction',
    description: 'สรุปเนื้อหาเบื้องต้นและแนวคิดหลักของวิชา',
    isPined: true,
  ),
  UtilityModel(
    courseId: 'CS102',
    type: UtilityType.note,
    title: 'โน้ต OOP Concepts',
    description: 'Encapsulation, Inheritance, Polymorphism, Abstraction',
    isPined: false,
  ),
  UtilityModel(
    courseId: 'general',
    type: UtilityType.note,
    title: 'ตารางสอบกลางภาค',
    description: 'รวมตารางสอบกลางภาคทุกวิชา ภาคเรียนที่ 2/2568',
    isPined: true,
  ),
  UtilityModel(
    courseId: 'CS103',
    type: UtilityType.note,
    title: 'สรุป Sorting Algorithms',
    description: 'เปรียบเทียบ Bubble, Merge, Quick Sort พร้อม Big-O',
    isPined: false,
  ),
  UtilityModel(
    courseId: 'CS104',
    type: UtilityType.note,
    title: 'โน้ต Database Normalization',
    description: '1NF, 2NF, 3NF และ BCNF พร้อมตัวอย่าง',
    isPined: true,
  ),
  UtilityModel(
    courseId: 'general',
    type: UtilityType.note,
    title: 'รายการหนังสือที่ต้องอ่าน',
    description: 'รวมหนังสือและแหล่งอ้างอิงสำหรับทุกวิชาในเทอมนี้',
    isPined: false,
  ),
];