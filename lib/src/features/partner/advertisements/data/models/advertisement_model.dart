import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AdvertisementModel {
  final String id;
  final String userId; // user id ของผู้โพส
  final String topic;
  final String description;
  final String imageUrl;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;

  static final _uuid = Uuid();

  AdvertisementModel({
    id,
    required this.userId,
    required this.topic,
    required this.description,
    required this.imageUrl,
    isPublished,
    createdAt,
    updatedAt,
  }) :  id = id ?? _uuid.v7(),
        isPublished = isPublished ?? false,
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // final String id;
  // final String userId; // user id ของผู้โพส
  // final String topic;
  // final String description;
  // final String imageUrl;
  // final bool isPublished;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  AdvertisementModel copyWith({
    String? id,
    String? userId,
    String? topic,
    String? description,
    String? imageUrl,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdvertisementModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt
    );
  }

  factory AdvertisementModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return AdvertisementModel(
      id: data['id'],
      userId: data['userId'],
      topic: data['topic'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      isPublished: data['isPublished'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'topic': topic,
      'description': description,
      'imageUrl': imageUrl,
      'isPublished': isPublished,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}