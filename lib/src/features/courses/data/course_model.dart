class CourseModel {
  final String id;
  final String name;
  final String? description;

  CourseModel({required this.id, required this.name, this.description});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
