import '../../domain/entities/author.dart';

class AuthorModel extends Author {
  const AuthorModel({
    required super.id,
    required super.user,
    super.bio,
    super.avatar,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      user: json['user'],
      bio: json['bio'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'user': user, 'bio': bio, 'avatar': avatar};
  }
}
