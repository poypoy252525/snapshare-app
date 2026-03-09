import 'package:snapshare/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.username,
    super.avatar,
    super.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;

    return UserModel(
      id: json['pk'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatar: profile?['avatar'] as String?,
      bio: profile?['bio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile': {'avatar': avatar, 'bio': bio},
    };
  }
}
