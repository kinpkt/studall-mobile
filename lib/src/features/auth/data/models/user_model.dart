import 'package:json_annotation/json_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './role.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? fullName;
  final String? photoUrl;
  final bool isBanned;
  final Role? lastActiveRole;
  final List<Role> roles;

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.fullName,
    this.photoUrl,
    this.isBanned = false,
    this.lastActiveRole,
    this.roles = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromFirebase(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      username: '',
      fullName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
      isBanned: false,
      lastActiveRole: null,
      roles: [],
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      email: data['email'] as String,
      username: data['username'] as String,
      fullName: data['fullName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      isBanned: data['isBanned'] as bool? ?? false,
      lastActiveRole: data['lastActiveRole'] != null
          ? Role.values.firstWhere(
              (role) => role.toString() == data['lastActiveRole'])
          : null,
      roles: (data['roles'] as List<dynamic>?)
              ?.map((roleStr) => Role.values.firstWhere(
                  (role) => role.toString() == roleStr))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'isBanned': isBanned,
      'lastActiveRole': lastActiveRole?.toString(),
      'roles': roles.map((role) => role.toString()).toList(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? fullName,
    String? photoUrl,
    bool? isBanned,
    Role? lastActiveRole,
    List<Role>? roles,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      isBanned: isBanned ?? this.isBanned,
      lastActiveRole: lastActiveRole ?? this.lastActiveRole,
      roles: roles ?? this.roles,
    );
  }
}
