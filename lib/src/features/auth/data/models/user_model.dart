import 'package:firebase_auth/firebase_auth.dart';
import './role.dart';

class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final bool isBanned;
  final Role? lastActiveRole;
  final List<Role> roles;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.isBanned = false,
    this.lastActiveRole,
    this.roles = const [],
  });

  factory UserModel.fromFirebase(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ?? '',
      photoUrl: firebaseUser.photoURL,
      isBanned: false,
      lastActiveRole: null,
      roles: [],
    );
  }

factory UserModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return UserModel(
      id: docId,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? 'ผู้ใช้งาน',
      photoUrl: data['photoUrl'] as String?,
      isBanned: data['isBanned'] as bool? ?? false,
      lastActiveRole: data['lastActiveRole'] != null
          ? Role.values.firstWhere(
              (role) => role.name == data['lastActiveRole'],
              orElse: () => Role.values.first,
            )
          : null,
      roles:
          (data['roles'] as List<dynamic>?)
              ?.map(
                (roleStr) => Role.values.firstWhere(
                  (role) => role.name == roleStr,
                  orElse: () => Role.values.first,
                ),
              )
              .toList() ??
          [],
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'email': email,
      'username': displayName,
      'photoUrl': photoUrl,
      'isBanned': isBanned,
      'lastActiveRole': lastActiveRole?.name,
      'roles': roles.map((role) => role.name).toList(),
    };
  }

  void debugPrint() {
    print(
      'UserModel: {id: $id, email: $email, displayName: $displayName, photoUrl: $photoUrl, isBanned: $isBanned, lastActiveRole: $lastActiveRole, roles: $roles}',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    bool? isBanned,
    Role? lastActiveRole,
    List<Role>? roles,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      isBanned: isBanned ?? this.isBanned,
      lastActiveRole: lastActiveRole ?? this.lastActiveRole,
      roles: roles ?? this.roles,
    );
  }
}
