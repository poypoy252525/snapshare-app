import 'package:snapshare/features/auth/data/models/user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access'] as String,
      refreshToken: json['refresh'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
