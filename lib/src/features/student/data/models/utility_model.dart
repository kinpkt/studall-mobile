import 'package:flutter/material.dart';

sealed class UtilityType {}

class UtilityModel {
  final String id;
  final String courseId;
  final String creatorUserId;
  final String? alternateLink;
  final UtilityType type;
  final DateTime creationTime;
  final DateTime updateTime;
  final String? title;
  final String? description;

  UtilityModel({
    required this.id,
    required this.courseId,
    required this.creatorUserId,
    this.alternateLink,
    required this.type,
    required this.creationTime,
    required this.updateTime,
    this.title,
    this.description,
  });

  UtilityModel copyWith({
    String? id,
    String? courseId,
    String? creatorUserId,
    String? alternateLink,
    UtilityType? type,
    DateTime? creationTime,
    DateTime? updateTime,
    String? title,
    String? description,
  }) {
    return UtilityModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      alternateLink: alternateLink ?? this.alternateLink,
      type: type ?? this.type,
      creationTime: creationTime ?? this.creationTime,
      updateTime: updateTime ?? this.updateTime,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

enum WorkType { assignment, shortAnswerQuestion, multipleChoiceQuestion }

class WorkUtilityType extends UtilityType {
  final WorkType workType;

  WorkUtilityType(this.workType);
}

class WorkUtilityModel extends UtilityModel {
  final DateTime? dueDateTime;
  final int? maxPoints;

  WorkUtilityModel({
    required super.id,
    required super.courseId,
    required super.creatorUserId,
    super.alternateLink,
    required WorkType workType,
    required super.creationTime,
    required super.updateTime,
    super.title,
    super.description,
    this.dueDateTime,
    this.maxPoints,
  }) : super(type: WorkUtilityType(workType));

  @override
  WorkUtilityModel copyWith({
    String? id,
    String? courseId,
    String? creatorUserId,
    String? alternateLink,
    UtilityType? type,
    DateTime? creationTime,
    DateTime? updateTime,
    String? title,
    String? description,
    WorkType? workType,
    DateTime? dueDateTime,
    int? maxPoints,
  }) {
    UtilityType? finalType;

    if (workType != null) {
      finalType = WorkUtilityType(workType);
    } else {
      finalType = type ?? this.type;
    }

    return WorkUtilityModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      alternateLink: alternateLink ?? this.alternateLink,
      workType: (finalType as WorkUtilityType).workType,
      creationTime: creationTime ?? this.creationTime,
      updateTime: updateTime ?? this.updateTime,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      maxPoints: maxPoints ?? this.maxPoints,
    );
  }
}

enum MaterialTypes { material }

class MaterialUtilityType extends UtilityType {
  final MaterialTypes materialType;

  MaterialUtilityType(this.materialType);
}

class MaterialUtilityModel extends UtilityModel {
  MaterialUtilityModel({
    required super.id,
    required super.courseId,
    required super.creatorUserId,
    super.alternateLink,
    required MaterialTypes materialType,
    required super.creationTime,
    required super.updateTime,
    super.title,
    super.description,
  }) : super(type: MaterialUtilityType(materialType));

  @override
  MaterialUtilityModel copyWith({
    String? id,
    String? courseId,
    String? creatorUserId,
    String? alternateLink,
    UtilityType? type,
    DateTime? creationTime,
    DateTime? updateTime,
    String? title,
    String? description,
    MaterialTypes? materialType,
  }) {
    UtilityType? finalType;

    if (materialType != null) {
      finalType = MaterialUtilityType(materialType);
    } else {
      finalType = type ?? this.type;
    }

    return MaterialUtilityModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      alternateLink: alternateLink ?? this.alternateLink,
      materialType: (finalType as MaterialUtilityType).materialType,
      creationTime: creationTime ?? this.creationTime,
      updateTime: updateTime ?? this.updateTime,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

enum AnnuouncementType { announcement }

class AnnouncementUtilityType extends UtilityType {
  final AnnuouncementType announcementType;

  AnnouncementUtilityType(this.announcementType);
}

class AnnouncementUtilityModel extends UtilityModel {
  AnnouncementUtilityModel({
    required super.id,
    required super.courseId,
    required super.creatorUserId,
    super.alternateLink,
    required AnnuouncementType announcementType,
    required super.creationTime,
    required super.updateTime,
    super.title,
    super.description,
  }) : super(type: AnnouncementUtilityType(announcementType));

  @override
  AnnouncementUtilityModel copyWith({
    String? id,
    String? courseId,
    String? creatorUserId,
    String? alternateLink,
    UtilityType? type,
    DateTime? creationTime,
    DateTime? updateTime,
    String? title,
    String? description,
    AnnuouncementType? announcementType,
  }) {
    UtilityType? finalType;

    if (announcementType != null) {
      finalType = AnnouncementUtilityType(announcementType);
    } else {
      finalType = type ?? this.type;
    }

    return AnnouncementUtilityModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      alternateLink: alternateLink ?? this.alternateLink,
      announcementType: (finalType as AnnouncementUtilityType).announcementType,
      creationTime: creationTime ?? this.creationTime,
      updateTime: updateTime ?? this.updateTime,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

/// TODO : Edit nextTime
enum EventType { event }

class EventUtilityType extends UtilityType {
  final EventType eventType;

  EventUtilityType(this.eventType);
}

class EventUtilityModel extends UtilityModel {
  EventUtilityModel({
    required super.id,
    required super.courseId,
    required super.creatorUserId,
    super.alternateLink,
    required EventType eventType,
    required super.creationTime,
    required super.updateTime,
    super.title,
    super.description,
  }) : super(type: EventUtilityType(eventType));

  @override
  EventUtilityModel copyWith({
    String? id,
    String? courseId,
    String? creatorUserId,
    String? alternateLink,
    UtilityType? type,
    DateTime? creationTime,
    DateTime? updateTime,
    String? title,
    String? description,
    EventType? eventType,
  }) {
    UtilityType? finalType;

    if (eventType != null) {
      finalType = EventUtilityType(eventType);
    } else {
      finalType = type ?? this.type;
    }

    return EventUtilityModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      alternateLink: alternateLink ?? this.alternateLink,
      eventType: (finalType as EventUtilityType).eventType,
      creationTime: creationTime ?? this.creationTime,
      updateTime: updateTime ?? this.updateTime,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

enum NoteType { note }

class NoteUtilityType extends UtilityType {
  final NoteType noteType;

  NoteUtilityType(this.noteType);
}

class NoteUtilityModel extends UtilityModel {
  final Image? image;

  NoteUtilityModel({
    required super.id,
    required super.courseId,
    required super.creatorUserId,
    super.alternateLink,
    required NoteType noteType,
    required super.creationTime,
    required super.updateTime,
    super.title,
    super.description,
    this.image,
  }) : super(type: NoteUtilityType(noteType));

  @override
  NoteUtilityModel copyWith({
    String? id,
    String? courseId,
    String? creatorUserId,
    String? alternateLink,
    UtilityType? type,
    DateTime? creationTime,
    DateTime? updateTime,
    String? title,
    String? description,
    NoteType? noteType,
    Image? image,
  }) {
    UtilityType? finalType;

    if (noteType != null) {
      finalType = NoteUtilityType(noteType);
    } else {
      finalType = type ?? this.type;
    }

    return NoteUtilityModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      alternateLink: alternateLink ?? this.alternateLink,
      noteType: (finalType as NoteUtilityType).noteType,
      creationTime: creationTime ?? this.creationTime,
      updateTime: updateTime ?? this.updateTime,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
