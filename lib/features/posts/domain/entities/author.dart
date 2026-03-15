import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final String id;
  final String userId;
  final String? avatar;
  final String username;

  const Author({
    required this.id,
    required this.userId,
    this.avatar,
    required this.username,
  });

  @override
  List<Object?> get props => [id, userId, avatar, username];
}
