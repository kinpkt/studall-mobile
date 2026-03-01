import 'package:uuid/uuid.dart';

class PartnerModel {
  final String id;
  final String name;
  final String description;
  final bool isPermitted;

  PartnerModel({
    id,
    required this.name,
    required this.description,
    isPermitted
  }) :  id = id ?? const Uuid().v7(),
        isPermitted = isPermitted ?? false;

  factory PartnerModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return PartnerModel(
      id: docId,
      name: data['name'],
      description: data['description'],
      isPermitted: data['isPermitted'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isPermitted': isPermitted,
    };
  }
}