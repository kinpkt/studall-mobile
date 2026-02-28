import 'package:uuid/uuid.dart';

class AdvertisementModel {
  final String id;
  final String requestId;
  final String userId; // user id ของผู้โพส
  final String topic;
  final String description;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  static final _uuid = Uuid();

  AdvertisementModel({
    id,
    required this.requestId,
    required this.userId,
    required this.topic,
    required this.description,
    required this.imageUrl,
    createdAt,
    updatedAt,
  }) :  id = id ?? _uuid.v7(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory AdvertisementModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return AdvertisementModel(
      id: data['id'],
      requestId: data['requestId'],
      userId: data['userId'],
      topic: data['topic'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'requestId': requestId,
      'userId': userId,
      'topic': topic,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}