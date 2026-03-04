class StudentModel {
  final String id;
  final double radius;

  StudentModel({required this.id, required this.radius});

  factory StudentModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return StudentModel(
      id: docId,
      radius: (data['radius'] as num?)?.toDouble() ?? 2000.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'radius': radius,
    };
  }
}