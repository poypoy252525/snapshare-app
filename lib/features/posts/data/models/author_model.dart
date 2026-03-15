import '../../domain/entities/author.dart';

class AuthorModel extends Author {
  const AuthorModel({
    required super.id,
    required super.userId,
    super.avatar,
    required super.username,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      userId: json['user_id'],
      avatar: json['avatar'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'avatar': avatar,
      'username': username,
    };
  }
}
