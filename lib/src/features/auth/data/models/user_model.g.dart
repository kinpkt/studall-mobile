// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'user_model.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
//   id: json['id'] as String,
//   email: json['email'] as String,
//   username: json['username'] as String,
//   fullName: json["fullName"] as String?,
//   photoUrl: json['photoUrl'] as String?,
//   isBanned: json['isBanned'] as bool? ?? false,
//   roles:
//       (json['roles'] as List<dynamic>?)
//           ?.map((e) => $enumDecode(_$RoleEnumMap, e))
//           .toList() ??
//       const [],
// );

// Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
//   'id': instance.id,
//   'email': instance.email,
//   'username': instance.username,
//   'fullName': instance.fullName,
//   'photoUrl': instance.photoUrl,
//   'isBanned': instance.isBanned,
//   'roles': instance.roles.map((e) => _$RoleEnumMap[e]!).toList(),
// };

// const _$RoleEnumMap = {
//   Role.admin: 'admin',
//   Role.student: 'student',
//   Role.partner: 'partner',
// };
